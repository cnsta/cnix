# Check if at least one argument is provided
if [ $# -lt 1 ]; then
  notify-send -t 5000 "Usage: spawn-or-focus.sh <APP_CLASS> [APP_CMD]"
  exit 1
fi

APP_CLASS="$1"   # Application's app_id (e.g. firefox)
APP_CMD="${2:-}" # Optional: Command to run the application

# Get the ID of the currently focused window
FOCUSED_ID=$(niri msg -j focused-window | jq -r '.id')

# Find windows matching the app class and read them into an array
readarray -t MATCHING_IDS < <(
  niri msg -j windows |
    jq -r --arg app_class "$APP_CLASS" '
      .[]
      | select(.app_id | ascii_downcase | contains($app_class | ascii_downcase))
      | .id
    '
)

# Launch the app and exit the script if the number of matching windows is zero
if [ ${#MATCHING_IDS[@]} -eq 0 ]; then
  # Use the app class as the command if no app command is supplied
  if [ -z "$APP_CMD" ]; then
    APP_CMD="$APP_CLASS"
  fi
  "$APP_CMD" &
  exit 0
fi

# Find the array index of the currently focused window
CURRENT_INDEX=-1
for INDEX in "${!MATCHING_IDS[@]}"; do
  if [ "${MATCHING_IDS[$INDEX]}" = "$FOCUSED_ID" ]; then
    CURRENT_INDEX=$INDEX
    break
  fi
done

# Cycle to the next matching array index if the currently focused ID was found
# in the array, otherwise set the target index to zero
if [ "$CURRENT_INDEX" -ge 0 ]; then
  TARGET_INDEX=$(((CURRENT_INDEX + 1) % ${#MATCHING_IDS[@]}))
else
  TARGET_INDEX=0
fi

# Switch focus to the target window stored in the array
niri msg action focus-window --id "${MATCHING_IDS[$TARGET_INDEX]}"
