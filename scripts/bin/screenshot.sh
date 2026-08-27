DIR="${SCREENSHOT_DIR:-$HOME/media/images}"
FILE="$DIR/screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"

notify() {
  notify-send -t 3000 "Screenshot" "$1" || true
}

mkdir -p "$DIR"

case "${1:-area}" in
area)
  geom=$(slurp) || exit 0 # empty selection or Escape
  grim -g "$geom" "$FILE"
  wl-copy <"$FILE"
  notify "Region copied and saved"
  ;;

output)
  # -o restricts the selection to whole outputs: click the one you want.
  geom=$(slurp -o) || exit 0
  grim -g "$geom" "$FILE"
  wl-copy <"$FILE"
  notify "Output copied and saved"
  ;;

screen)
  # No -g at all: grim captures every output side by side.
  grim "$FILE"
  wl-copy <"$FILE"
  notify "Screen copied and saved"
  ;;

ocr)
  geom=$(slurp) || exit 0
  text=$(grim -g "$geom" - | tesseract - - 2>/dev/null)
  if [ -z "${text//[[:space:]]/}" ]; then
    notify "OCR found no text"
    exit 0
  fi
  printf '%s' "$text" | wl-copy
  notify "OCR result copied to buffer"
  ;;

*)
  echo "usage: $0 [area|output|screen|ocr]" >&2
  exit 1
  ;;
esac
