if pgrep -f "pwvucontrol" >/dev/null; then
  pkill -f "pwvucontrol"
else
  if ! hyprctl dispatch exec pwvucontrol; then
    echo "Failed to launch Pwvucontrol"
    exit 1
  fi
fi
