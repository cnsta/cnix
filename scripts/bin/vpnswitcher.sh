# ensure single instance
LOCKFILE="/tmp/vpnswitcher.lock"
exec 200>"$LOCKFILE"
flock -n 200 || {
  echo "Another instance is already running."
  exit 1
}

# constants
TAILSCALE_SERVICE="tailscaled"
MENU_FILE=$(mktemp)
trap 'rm -f "$MENU_FILE"' EXIT

# state detection
CURRENT_WG=$(nmcli -t -f NAME,TYPE connection show --active | grep ":wireguard$" | cut -d: -f1 | head -n 1 || true)
IS_TS_ACTIVE=false
if systemctl is-active --quiet "$TAILSCALE_SERVICE"; then
  IS_TS_ACTIVE=true
fi

# menu generation
{
  if [ "$IS_TS_ACTIVE" = true ]; then
    printf "Tailscale (Service) [ACTIVE]\ttailscale\ttailscale\n"
  else
    printf "Tailscale (Service)\ttailscale\ttailscale\n"
  fi

  nmcli -t -f NAME,TYPE connection show | grep ":wireguard$" | cut -d: -f1 | while read -r wg_name; do
    if [[ "$wg_name" == "$CURRENT_WG" ]]; then
      printf "WireGuard (%s) [ACTIVE]\t%s\twireguard\n" "$wg_name" "$wg_name"
    else
      printf "WireGuard (%s)\t%s\twireguard\n" "$wg_name" "$wg_name"
    fi
  done

  printf "❌ Disconnect All\tNONE\tdisconnect\n"

} >"$MENU_FILE"

# fzf selection
SELECTION=$(fzf \
  --reverse \
  --delimiter="\t" \
  --with-nth=1 \
  --height=30% \
  --prompt=" > " \
  --header="Select VPN:" \
  <"$MENU_FILE")

# exit if cancelled
[[ -z "$SELECTION" ]] && exit 0

# parse selection
TARGET_NAME=$(cut -f2 <<<"$SELECTION")
TARGET_TYPE=$(cut -f3 <<<"$SELECTION")

echo "---"

# main logic
disconnect_all() {
  if [[ -n "$CURRENT_WG" ]]; then
    echo "⬇️  Disconnecting WireGuard ($CURRENT_WG)..."
    nmcli connection down "$CURRENT_WG"
  fi
  if [ "$IS_TS_ACTIVE" = true ]; then
    echo "⬇️  Stopping Tailscale..."
    sudo systemctl stop "$TAILSCALE_SERVICE"
  fi
}

case "$TARGET_TYPE" in
disconnect)
  disconnect_all
  echo "✅ All disconnected."
  ;;

tailscale)
  # only restart if we aren't already running it exclusively
  if [ "$IS_TS_ACTIVE" = true ] && [[ -z "$CURRENT_WG" ]]; then
    echo "✅ Tailscale is already the active VPN."
  else
    disconnect_all
    echo "⬆️  Starting Tailscale..."
    sudo systemctl start "$TAILSCALE_SERVICE"
  fi
  ;;

wireguard)
  if [[ "$TARGET_NAME" == "$CURRENT_WG" ]] && [ "$IS_TS_ACTIVE" = false ]; then
    echo "✅ $TARGET_NAME is already active."
  else
    disconnect_all
    echo "⬆️  Connecting to $TARGET_NAME..."
    nmcli connection up "$TARGET_NAME"
  fi
  ;;
esac
