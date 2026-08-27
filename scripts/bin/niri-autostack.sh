# niri-autostack: fold newly opened windows into the column they came from.
#
# USAGE:
#   niri-autostack '<APP_ID_REGEX>:<MAX>'
#
# EXAMPLE:
#   niri-autostack '^foot$:2' '^org\.wezfurlong\.wezterm$:3'

declare -A MAX=()
for rule in "$@"; do
  MAX["${rule%:*}"]="${rule##*:}"
done

if ((${#MAX[@]} == 0)); then
  echo "niri-autostack: no rules given, nothing to do" >&2
  exit 1
fi

# ids we have already made a decision about
declare -A SEEN=()

# Print the first rule regex matching $1, or fail.
matching_rule() {
  local app=$1 re
  for re in "${!MAX[@]}"; do
    if [[ $app =~ $re ]]; then
      printf '%s\n' "$re"
      return 0
    fi
  done
  return 1
}

handle_open() {
  local id=$1 app=$2
  local re max windows col row

  re=$(matching_rule "$app") || return 0
  max=${MAX[$re]}

  # Re-query rather than trusting the event payload: at the moment the event is
  # emitted the window may not have its final position in the layout yet.
  windows=$(niri msg -j windows) || return 0

  read -r col row < <(
    jq -r --argjson id "$id" '
      (map(select(.id == $id)) | .[0].layout.pos_in_scrolling_layout) as $p
      | if $p == null then "0 0" else "\($p[0]) \($p[1])" end
    ' <<<"$windows"
  ) || return 0

  # pos_in_scrolling_layout is 1-based (column, row) and null for floating
  # windows. Bail out if floating, already sharing a column, or leftmost.
  ((col > 1)) || return 0
  ((row == 1)) || return 0

  # The left-hand column must be non-empty, entirely made of windows matching
  # the same rule, and still have room.
  jq -e \
    --argjson col "$((col - 1))" \
    --arg re "$re" \
    --argjson max "$max" '
      map(select(.layout.pos_in_scrolling_layout[0]? == $col)) as $left
      | ($left | length) as $n
      | $n > 0 and $n < $max and all($left[]; (.app_id // "") | test($re; "i"))
    ' <<<"$windows" >/dev/null || return 0

  niri msg action consume-or-expel-window-left --id "$id" || true
}

niri msg -j event-stream | while IFS= read -r line; do
  case $line in
  *'"WindowsChanged"'*)
    # Initial snapshot. Mark everything as already handled so we don't try to
    # restack the whole session on startup.
    while read -r id; do
      SEEN[$id]=1
    done < <(jq -r '.WindowsChanged.windows[].id' <<<"$line" || true)
    ;;
  *'"WindowOpenedOrChanged"'*)
    # This event also fires on title/focus changes, so only act the first time
    # we see a given id.
    id=$(jq -r '.WindowOpenedOrChanged.window.id // empty' <<<"$line" || true)
    if [[ -n $id && -z ${SEEN[$id]-} ]]; then
      SEEN[$id]=1
      app=$(jq -r '.WindowOpenedOrChanged.window.app_id // ""' <<<"$line" || true)
      handle_open "$id" "$app"
    fi
    ;;
  *'"WindowClosed"'*)
    id=$(jq -r '.WindowClosed.id // empty' <<<"$line" || true)
    if [[ -n $id ]]; then
      unset "SEEN[$id]"
    fi
    ;;
  esac
done
