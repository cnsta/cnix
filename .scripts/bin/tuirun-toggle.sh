#!/usr/bin/env bash

# Path to the tuirun executable
TUIRUN_PATH="/etc/profiles/per-user/$USER/bin/tuirun"
LOGFILE="$HOME/tuirun_debug.log"

echo "Launching tuirun..." >>"$LOGFILE"
date >>"$LOGFILE"

if pgrep -f "alacritty --title tuirun" >/dev/null; then
  echo "Terminating existing tuirun process" >>"$LOGFILE"
  pkill -f "alacritty --title tuirun"
else
  echo "Starting new tuirun process" >>"$LOGFILE"
  if ! hyprctl dispatch exec "alacritty --title tuirun -e sh -c '$TUIRUN_PATH'"; then
    echo "Failed to launch tuirun in foot terminal" >>"$LOGFILE"
    exit 1
  fi
  sleep 1 # Give it a second to start
  echo "Checking if tuirun process is still running..." >>"$LOGFILE"
  if pgrep -f "$TUIRUN_PATH" >/dev/null; then
    echo "tuirun is running" >>"$LOGFILE"
  else
    echo "tuirun exited prematurely" >>"$LOGFILE"
  fi
fi
