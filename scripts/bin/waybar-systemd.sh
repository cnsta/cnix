# This is a modified version of a script from @maximbaz
SYSTEMCTL="/run/current-system/sw/bin/systemctl"
WC="/run/current-system/sw/bin/wc"

failed_user_output=$("$SYSTEMCTL" --plain --no-legend --user list-units --state=failed --type=service 2>/dev/null)
failed_system_output=$("$SYSTEMCTL" --plain --no-legend list-units --state=failed --type=service)

if [[ -z "$failed_system_output" ]]; then
  failed_systemd_count=0
else
  failed_systemd_count=$("$WC" -l <<<"$failed_system_output")
fi

if [[ -z "$failed_user_output" ]]; then
  failed_user_count=0
else
  failed_user_count=$("$WC" -l <<<"$failed_user_output")
fi

total_failed=$((failed_systemd_count + failed_user_count))

if [[ "$total_failed" -eq 0 ]]; then
  printf '{"text": ""}\n'
else
  tooltip=""

  if [[ -n "$failed_system_output" ]]; then
    failed_system=$(echo "$failed_system_output" | /run/current-system/sw/bin/awk '{print $1}')
    tooltip+="Failed system services: "
    if [[ "$failed_systemd_count" -gt 1 ]]; then
      failed_system_indented="${failed_system//$'\n'/\\n  }"
      tooltip+="$failed_system_indented"
    else
      tooltip+="$failed_system"
    fi
  fi

  if [[ -n "$failed_user_output" ]]; then
    failed_user=$(echo "$failed_user_output" | /run/current-system/sw/bin/awk '{print $1}')
    if [[ -n "$tooltip" ]]; then tooltip+="\n"; fi
    tooltip+="Failed user services: "
    if [[ "$failed_user_count" -gt 1 ]]; then
      failed_user_indented="${failed_user//$'\n'/\\n  }"
      tooltip+="$failed_user_indented"
    else
      tooltip+="$failed_user"
    fi
  fi

  escaped_tooltip="${tooltip//$'\\n'/\\\\n}"
  printf '{"text": " %d", "tooltip": "%s"}\n' "$total_failed" "$escaped_tooltip"
fi
