DIR="${SCREENSHOT_DIR:-$HOME/media/images}"
# Milliseconds, so two shots in the same second don't overwrite each other.
FILE="$DIR/screenshot from $(date '+%Y-%m-%d %H-%M-%S.%3N').png"

# Pressing the key again while a selection is open cancels it instead of
# stacking a second selector.
pkill -x slurp && exit 0

notify() {
  notify-send -a screenshot -t 3000 "$@" || true
}

# shoot <label> [grim args...]
shoot() {
  local label=$1
  shift
  mkdir -p "$DIR"
  grim "$@" "$FILE"
  wl-copy --type image/png <"$FILE"
  notify -i "$FILE" "Screenshot" "$label copied and saved"
}

# Rect of every window on a shown workspace, in slurp's "x,y wxh" format.
window_rects() {
  delctl --json windows | jq -r '
    .windows[] | select((.hidden | not) and .geometry != null) | .geometry
    | "\(.x),\(.y) \(.width)x\(.height)"'
}

case "${1:-area}" in
area)
  geom=$(slurp) || exit 0 # empty selection or Escape
  shoot "Region" -g "$geom"
  ;;

window)
  # -r restricts the selection to the given rects: click the window you want.
  geom=$(window_rects | slurp -r) || exit 0
  shoot "Window" -g "$geom"
  ;;

focused)
  geom=$(delctl --json focused | jq -r '
    .focused_window.geometry // empty
    | "\(.x),\(.y) \(.width)x\(.height)"') || true
  if [ -z "$geom" ]; then
    notify "Screenshot" "No focused window"
    exit 0
  fi
  shoot "Window" -g "$geom"
  ;;

output)
  # The focused output, click one instead if delta can't be asked.
  name=$(delctl --json outputs | jq -r '.outputs[] | select(.focused) | .name' | head -n1) || true
  if [ -n "$name" ]; then
    shoot "Output" -o "$name"
  else
    geom=$(slurp -o) || exit 0
    shoot "Output" -g "$geom"
  fi
  ;;

screen)
  # No -g at all: grim captures every output side by side.
  shoot "Screen"
  ;;

ocr)
  geom=$(slurp) || exit 0
  text=$(grim -g "$geom" - | tesseract - - 2>/dev/null)
  if [ -z "${text//[[:space:]]/}" ]; then
    notify "Screenshot" "OCR found no text"
    exit 0
  fi
  printf '%s' "$text" | wl-copy
  notify "Screenshot" "OCR result copied to buffer"
  ;;

*)
  echo "usage: $0 [area|window|focused|output|screen|ocr]" >&2
  exit 1
  ;;
esac
