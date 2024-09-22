# Log file location
LOGFILE="/.cache/tuirun/tuirun-toggle.log"
# Redirect all output and errors to the log file
exec >>"$LOGFILE" 2>&1
# Enable command tracing
set -x

echo "Script started at $(date)"

# Log the environment variables
echo "Environment variables:"
env

# Define TERMINAL if not set
TERMINAL="${TERMINAL:-foot}"
echo "TERMINAL is set to: $TERMINAL"

# Ensure USER is set
USER="${USER:-$(whoami)}"
echo "USER is set to: $USER"

# Path to the tuirun executable
TUIRUN_PATH="/etc/profiles/per-user/$USER/bin/tuirun"
echo "TUIRUN_PATH is set to: $TUIRUN_PATH"

# Use absolute paths for commands
PGREP="/run/current-system/sw/bin/pgrep"
PKILL="/run/current-system/sw/bin/pkill"
HYPRCTL="/etc/profiles/per-user/$USER/bin/hyprctl"

echo "Checking if tuirun is already running..."

if "$PGREP" -f "$TERMINAL --title tuirun" >/dev/null; then
  echo "Found existing tuirun process. Terminating..."
  "$PKILL" -f "$TERMINAL --title tuirun"
else
  echo "No existing tuirun process. Starting a new one..."
  "$HYPRCTL" dispatch exec "$TERMINAL --title tuirun -e $TUIRUN_PATH"
fi

echo "Script finished at $(date)"
