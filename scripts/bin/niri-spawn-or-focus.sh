# niri-spawn-or-focus: focus, cycle through, or spawn an application.
#
#   niri-spawn-or-focus [--max N] <APP_ID_REGEX> [COMMAND [ARGS...]]
#
#   no matching window                -> spawn COMMAND
#   matching windows, none focused    -> focus the first one in layout order
#   a matching window is focused:
#       fewer than N matches exist    -> spawn another one
#                                        (niri-autostack folds it into the
#                                         column you spawned it from)
#       N or more matches exist       -> cycle to the next match
#
# --max defaults to 1, i.e. plain focus-or-spawn with cycling.

max=1
if [[ ${1-} == --max ]]; then
  max=${2:?--max needs a number}
  shift 2
fi

if (($# < 1)); then
  echo "usage: niri-spawn-or-focus [--max N] <APP_ID_REGEX> [COMMAND...]" >&2
  exit 1
fi

app_re=$1
shift
if (($# == 0)); then
  # No command given: fall back to the app-id with regex anchors stripped.
  set -- "${app_re//[\^\$]/}"
fi

windows=$(niri msg -j windows)
focused=$(jq -r 'map(select(.is_focused)) | .[0].id // empty' <<<"$windows")

mapfile -t ids < <(
  jq -r --arg re "$app_re" '
    map(select((.app_id // "") | test($re; "i")))
    | sort_by(
        .workspace_id // 0,
        (.layout.pos_in_scrolling_layout // [0, 0])[0],
        (.layout.pos_in_scrolling_layout // [0, 0])[1]
      )
    | .[].id
  ' <<<"$windows"
)

count=${#ids[@]}

if ((count == 0)); then
  niri msg action spawn -- "$@"
  exit 0
fi

# Position of the focused window within the matches, or -1 if it isn't one.
cur=-1
for i in "${!ids[@]}"; do
  if [[ ${ids[i]} == "$focused" ]]; then
    cur=$i
    break
  fi
done

if ((cur < 0)); then
  niri msg action focus-window --id "${ids[0]}"
  exit 0
fi

if ((count < max)); then
  niri msg action spawn -- "$@"
  exit 0
fi

niri msg action focus-window --id "${ids[$(((cur + 1) % count))]}"
