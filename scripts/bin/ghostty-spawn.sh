# Ghostty spawn-or-focus logic for Niri:
# If no Ghostty windows exist, spawn one.
# If focused window is not Ghostty, focus the first Ghostty instance.
# If Ghostty is focused and only one instance exists, spawn + consume into stack.
# If Ghostty is focused and two instances already exist, spawn a new separate one.
# Cycle repeats: focus first > allow stack of 2 > reset on 3rd.

APP_ID="com.mitchellh.ghostty"
APP_CMD="ghostty"

WINDOW_DATA=$(niri msg -j windows)

readarray -t GHOSTTY_IDS < <(
  echo "$WINDOW_DATA" | jq -r --arg app_id "$APP_ID" '
    [ .[] | select(.app_id == $app_id) ]
    | sort_by(.layout.pos_in_scrolling_layout // [0,0])
    | .[].id
  '
)

COUNT=${#GHOSTTY_IDS[@]}

FOCUSED_IS_GHOSTTY=$(
  echo "$WINDOW_DATA" | jq -r --arg app_id "$APP_ID" '
    any(.[]; .app_id == $app_id and .is_focused)
  '
)

spawn_normal() {
  "$APP_CMD" &
}

spawn_and_consume() {
  local initial_ids=("$@")
  "$APP_CMD" &
  local pid=$!

  for _ in {1..50}; do
    readarray -t after_ids < <(
      niri msg -j windows | jq -r --arg app_id "$APP_ID" '
        [ .[] | select(.app_id == $app_id) ]
        | sort_by(.layout.pos_in_scrolling_layout // [0,0])
        | .[].id
      '
    )

    NEW_ID=""
    for id in "${after_ids[@]}"; do
      [[ " ${initial_ids[*]} " == *" $id "* ]] || NEW_ID="$id"
    done

    if [ -n "$NEW_ID" ]; then
      niri msg action focus-window --id "${initial_ids[$((${#initial_ids[@]} - 1))]}"
      niri msg action consume-window-into-column
      break
    fi
    sleep 0.05
  done

  wait "$pid" 2>/dev/null || true
}

if ((COUNT == 0)); then
  spawn_normal
  exit 0
fi

if [ "$FOCUSED_IS_GHOSTTY" != "true" ]; then
  niri msg action focus-window --id "${GHOSTTY_IDS[0]}"
  exit 0
fi

if ((COUNT % 2 == 0)); then
  spawn_normal
else
  spawn_and_consume "${GHOSTTY_IDS[@]}"
fi
