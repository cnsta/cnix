#!/bin/sh
if pgrep -f floatranger; then
  pkill -f floatranger
else
  hyprctl dispatch exec 'foot --title floatranger ranger'
fi
