#!/usr/bin/env bash
if pgrep -f "foot --title floatcal" >/dev/null; then
  # If a process with "foot --title floatcal" is found, kill it
  pkill -f "foot --title floatcal"
else
  # Otherwise, launch it via hyprctl
  if ! hyprctl dispatch exec 'foot --title floatcal calcurse'; then
    echo "Failed to launch calcurse in foot terminal"
    exit 1
  fi
fi
