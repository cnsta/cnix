TAILSCALE_SERVICE="tailscaled"

# check if tailscale service is running
is_tailscale_active() {
  systemctl is-active --quiet "$TAILSCALE_SERVICE"
}

# name of active wireguard connection (if present)
get_active_wireguard() {
  nmcli -t -f NAME,TYPE connection show --active |
    grep ":wireguard$" |
    cut -d: -f1 |
    head -n 1 || true
}

# get list of all wg connections
get_all_wireguard_conns() {
  nmcli -t -f NAME,TYPE connection show |
    grep ":wireguard$" |
    cut -d: -f1
}

# check current status
CURRENT_STATUS=""
ACTIVE_TAILSCALE=""
ACTIVE_WIREGUARD=""

# check tailscale with systemctl
if is_tailscale_active; then
  ACTIVE_TAILSCALE="true"
  CURRENT_STATUS="Tailscale is UP"
fi

# use nmcli to check wireguard connections
DETECTED_ACTIVE_WG=$(get_active_wireguard)
if [[ -n "$DETECTED_ACTIVE_WG" ]]; then
  ACTIVE_WIREGUARD="$DETECTED_ACTIVE_WG"

  if [[ -n "$CURRENT_STATUS" ]]; then
    CURRENT_STATUS="$CURRENT_STATUS + WireGuard ($ACTIVE_WIREGUARD)"
  else
    CURRENT_STATUS="WireGuard is UP ($ACTIVE_WIREGUARD)"
  fi
fi

if [[ -z "$CURRENT_STATUS" ]]; then
  CURRENT_STATUS="No VPN Active"
fi

# use temp file for menu
MENU_FILE=$(mktemp)
trap 'rm -f $MENU_FILE' EXIT

# add ts option  (label \t name \t type)
printf "Tailscale (Service)\ttailscale\ttailscale\n" >>"$MENU_FILE"

# dynamically add available wireguard connections
while IFS= read -r wg_name; do
  [[ -z "$wg_name" ]] && continue
  printf "WireGuard (%s)\t%s\twireguard\n" "$wg_name" "$wg_name" >>"$MENU_FILE"
done < <(get_all_wireguard_conns)

# add disconnect option
printf "❌ Disconnect All\tNONE\tdisconnect\n" >>"$MENU_FILE"

# fzf ui
SELECTION=$(
  fzf \
    --reverse \
    --delimiter="\t" \
    --with-nth=1 \
    --height=30% \
    --prompt=" 🌐 Status: [$CURRENT_STATUS] > " \
    --header="Available connections:" \
    <"$MENU_FILE"
)

# exit if cancelled
[[ -z "$SELECTION" ]] && exit 0

# parse the selection
TARGET_NAME=$(printf "%s" "$SELECTION" | cut -f2)
TARGET_TYPE=$(printf "%s" "$SELECTION" | cut -f3)

echo "---"

# handle "Disconnect All"
if [[ "$TARGET_TYPE" == "disconnect" ]]; then
  if [[ -n "$ACTIVE_TAILSCALE" ]]; then
    echo "⬇️ Stopping Tailscale service..."
    sudo systemctl stop "$TAILSCALE_SERVICE"
  fi
  if [[ -n "$ACTIVE_WIREGUARD" ]]; then
    echo "⬇️ Disconnecting WireGuard ($ACTIVE_WIREGUARD)..."
    nmcli connection down "$ACTIVE_WIREGUARD"
  fi
  echo "✅ All VPNs disconnected."
  exit 0
fi

# conflict(1): user wants wg, but ts is active
if [[ "$TARGET_TYPE" == "wireguard" && -n "$ACTIVE_TAILSCALE" ]]; then
  echo "🔄 Switching: Tailscale -> WireGuard"
  echo "⬇️ Stopping Tailscale service..."
  sudo systemctl stop "$TAILSCALE_SERVICE"
fi

# conflict(2): user wants ts, but wg is active
if [[ "$TARGET_TYPE" == "tailscale" && -n "$ACTIVE_WIREGUARD" ]]; then
  echo "🔄 Switching: WireGuard -> Tailscale"
  echo "⬇️ Disconnecting WireGuard ($ACTIVE_WIREGUARD)..."
  nmcli connection down "$ACTIVE_WIREGUARD"
fi

# conflict(3): wireguard switching if one is active
if [[ "$TARGET_TYPE" == "wireguard" && -n "$ACTIVE_WIREGUARD" && "$ACTIVE_WIREGUARD" != "$TARGET_NAME" ]]; then
  echo "🔄 Switching: WireGuard ($ACTIVE_WIREGUARD) -> WireGuard ($TARGET_NAME)"
  echo "⬇️ Disconnecting previous WireGuard..."
  nmcli connection down "$ACTIVE_WIREGUARD"
fi

# final logic
if [[ "$TARGET_TYPE" == "tailscale" ]]; then
  if is_tailscale_active; then
    echo "✅ Tailscale is already running."
  else
    echo "⬆️ Starting Tailscale service..."
    sudo systemctl start "$TAILSCALE_SERVICE"
    if is_tailscale_active; then
      echo "✅ Tailscale started successfully."
    else
      echo "❌ Failed to start Tailscale."
    fi
  fi

elif [[ "$TARGET_TYPE" == "wireguard" ]]; then
  if [[ "$TARGET_NAME" == "$ACTIVE_WIREGUARD" ]]; then
    echo "✅ $TARGET_NAME is already active."
  else
    echo "⬆️ Connecting to $TARGET_NAME..."
    nmcli connection up "$TARGET_NAME"
  fi
fi
