# This is a very slightly modified version of a script from @maximbaz
PROGRESS="/run/current-system/sw/bin/progress"
PERL="/run/current-system/sw/bin/perl"
SED="/run/current-system/sw/bin/sed"

output="$("$PROGRESS" -q)"
text="$(printf "%s" "$output" | "$SED" 's/\[[^]]*\] //g' | /run/current-system/sw/bin/awk 'BEGIN { ORS=" " } NR%3==1 { op=$1 } NR%3==2 { pct=($1+0); if (op != "gpg" && op != "coreutils" && pct > 0 && pct < 100) { print op, $1 } }')"
tooltip="$(printf "%s" "$output" | "$PERL" -pe 's/\n/\\n/g' | "$PERL" -pe 's/(?:\\n)+$//')"

printf '{"text": "%s", "tooltip": "%s"}\n' "$text" "$tooltip"
