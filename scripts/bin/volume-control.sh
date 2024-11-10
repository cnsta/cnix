#!/usr/bin/env bash

iDIR="$HOME/.config/mako/icons"

# Get Volume
get_volume() {
  pamixer --get-volume
}

# Get icons
get_icon() {
  current=$(get_volume)
  case $current in
  0)
    echo "$iDIR/vol_off.svg"
    ;;
  [1-9] | [1-2][0-9] | 30)
    echo "$iDIR/vol_mute.svg"
    ;;
  [3-5][0-9] | 60)
    echo "$iDIR/vol_down.svg"
    ;;
  *)
    echo "$iDIR/vol_up.svg"
    ;;
  esac
}

# Notify
notify_user() {
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume : $(get_volume) %"
}

# Increase Volume
inc_volume() {
  pamixer -i 5 && notify_user
}

# Decrease Volume
dec_volume() {
  pamixer -d 5 && notify_user
}

# Toggle Mute
toggle_mute() {
  if pamixer --get-mute | grep -q "false"; then
    pamixer -m && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/vol_off.svg" "Volume Switched OFF"
  else
    pamixer -u && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume Switched ON"
  fi
}

# Toggle Mic
toggle_mic() {
  if pamixer --default-source --get-mute | grep -q "false"; then
    pamixer --default-source -m && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/mic_off.svg" "Microphone Switched OFF"
  else
    pamixer --default-source -u && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/mic.svg" "Microphone Switched ON"
  fi
}

# Get mic icons
get_mic_icon() {
  echo "$iDIR/mic.svg"
}

# Notify
notify_mic_user() {
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_mic_icon)" "Mic-Level : $(pamixer --default-source --get-volume) %"
}

# Increase MIC Volume
inc_mic_volume() {
  pamixer --default-source -i 5 && notify_mic_user
}

# Decrease MIC Volume
dec_mic_volume() {
  pamixer --default-source -d 5 && notify_mic_user
}

# Execute accordingly
case $1 in
--get)
  get_volume
  ;;
--inc)
  inc_volume
  ;;
--dec)
  dec_volume
  ;;
--toggle)
  toggle_mute
  ;;
--toggle-mic)
  toggle_mic
  ;;
--get-icon)
  get_icon
  ;;
--get-mic-icon)
  get_mic_icon
  ;;
--mic-inc)
  inc_mic_volume
  ;;
--mic-dec)
  dec_mic_volume
  ;;
*)
  get_volume
  ;;
esac
