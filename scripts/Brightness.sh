#!/bin/bash
## Brightness 💡##

# Control backlight brightness

# Notification settings
device="*"
icon="brightnesssettings"
prompt="Brightness : "

# Set device type
if [ "$2" == "--keys" ]; then
  device="*::kbd_backlight"
  prompt="Keyboard backlight : "
fi

# Get brightness
get_brightness() {
  brightnessctl -d "$device" -m | awk -F "," '{ print $4 }'
}

# Notify
notify_brightness() {
  notify-send -e -h \
    string:x-canonical-private-synchronous:brightness -h \
    int:value:"$(get_brightness)" -u low -i \
    "$icon" "$prompt$(get_brightness)"
}

# Change brightness
change_brightness() {
  brightnessctl set -d "$device" "$1" && notify_brightness
}

# Execute accordingly
case "$1" in
"--get")
  get_brightness
  ;;
"--inc")
  change_brightness "+10%"
  ;;
"--dec")
  change_brightness "10%-"
  ;;
*)
  get_brightness
  ;;
esac
