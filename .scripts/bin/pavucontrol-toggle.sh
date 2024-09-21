#!/usr/bin/env bash
if pgrep -f "pavucontrol" >/dev/null; then
  pkill -f "pavucontrol"
else
  if ! hyprctl dispatch exec pavucontrol; then
    echo "Failed to launch Pavucontrol"
    exit 1
  fi
fi
