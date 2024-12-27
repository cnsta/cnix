MAKOCTL="/etc/profiles/per-user/$USER/bin/makoctl"
GREP="/run/current-system/sw/bin/grep"

if "$MAKOCTL" mode | "$GREP" -q "default"; then
  # Default mode
  echo "󰂚"
else
  # Do-not-disturb mode
  echo "󱏧"
fi
