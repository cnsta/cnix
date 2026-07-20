MAKOCTL="/etc/profiles/per-user/$USER/bin/makoctl"
GREP="/run/current-system/sw/bin/grep"

if "$MAKOCTL" mode | "$GREP" -q "default"; then
  "$MAKOCTL" set-mode do-not-disturb
else
  "$MAKOCTL" set-mode default
fi
