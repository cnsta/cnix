#!/usr/bin/env bash

iDIR="$HOME/.config/mako/icons"

# Get Volume
get_volume() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@
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
  wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && notify_user
}

# Decrease Volume
dec_volume() {
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify_user
}

# Toggle Mute
toggle_mute() {
  if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep "[MUTED]"; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume Switched ON"
  else
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/vol_off.svg" "Volume Switched OFF"
  fi
}

# Toggle Mic
toggle_mic() {
  if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep "[MUTED]"; then
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/mic.svg" "Microphone Switched ON"
  else
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1 && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/mic_off.svg" "Microphone Switched OFF"
  fi
}

# Get mic icons
get_mic_icon() {
  echo "$iDIR/mic.svg"
}

# Notify
notify_mic_user() {
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_mic_icon)" "Mic-Level : $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@) %"
}

# Increase MIC Volume
inc_mic_volume() {
  wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 5%+ && notify_mic_user
}

# Decrease MIC Volume
dec_mic_volume() {
  wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 5%- && notify_mic_user
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
