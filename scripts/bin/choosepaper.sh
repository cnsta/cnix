export bg_dir="$HOME/media/images/bgs/"
find "$bg_dir" -type f | fzf --reverse --preview 'pistol {}' | while read -r img; do
  pkill swaybg || true
  swaybg -m fill -o '*' -i "$img" &
done
