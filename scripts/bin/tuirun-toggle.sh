# Define TERMINAL if not set
TERMINAL="${TERMINAL:-foot}"

# Path to the tuirun executable
TUIRUN_PATH="/run/current-system/sw/bin/uwsm app -- tuirun"

# Use absolute paths for commands
PGREP="/run/current-system/sw/bin/pgrep"
PKILL="/run/current-system/sw/bin/pkill"
HYPRCTL="/etc/profiles/per-user/$USER/bin/hyprctl"

# Determine OPTIONS based on TERMINAL
if [ "$TERMINAL" = "foot" ]; then
  OPTIONS="--override=main.pad=0x0"
elif [ "$TERMINAL" = "alacritty" ]; then
  OPTIONS="--option window.padding.x=0 --option window.padding.y=0"
else
  OPTIONS=""
fi

# Matching pattern for the process
MATCH_PATTERN="$TERMINAL --title tuirun"

if "$PGREP" -f "$MATCH_PATTERN" >/dev/null; then
  "$PKILL" -f "$MATCH_PATTERN"
else
  # Construct the command
  CMD="$TERMINAL --title tuirun"
  if [ -n "$OPTIONS" ]; then
    CMD="$CMD $OPTIONS"
  fi
  CMD="$CMD -e $TUIRUN_PATH"

  # Launch the terminal with OPTIONS
  uwsm app -- "$HYPRCTL" dispatch exec "$CMD"
fi
