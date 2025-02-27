# Define TERMINAL if not set
TERMINAL="${TERMINAL:-foot}"

# Use absolute paths for commands
PGREP="/run/current-system/sw/bin/pgrep"
PKILL="/run/current-system/sw/bin/pkill"
UWSM="/run/current-system/sw/bin/uwsm"
TUIRUN_PATH="/etc/profiles/per-user/$USER/bin/tuirun"

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
  echo "$(date): Killing existing process"
  "$PKILL" -f "$MATCH_PATTERN"
else
  # Log the environment for debugging
  env >/tmp/script_env.txt
  # Construct the command as an array for proper argument handling
  CMD=("$TERMINAL" "--title" "tuirun")
  if [ -n "$OPTIONS" ]; then
    CMD+=("$OPTIONS")
  fi
  CMD+=("-e" "$TUIRUN_PATH")

  echo "$(date): Executing command: ${CMD[*]}"
  # Use eval to expand the command or pass the arguments directly
  "$UWSM" app -- "${CMD[@]}"
fi
