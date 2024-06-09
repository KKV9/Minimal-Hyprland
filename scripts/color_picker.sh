#!/bin/sh
## Color picker 🌈##

# Hyprpicker wrapper

result=$(hyprpicker -an)

if [ -z  "$result" ]; then
  exit 0
fi

# Reload mako with picked color
killall mako
mako --border-color "$result" &
# Send notification
notify-send -u low -i "clipboard" "Clipboard" "Copied: $result"
# Wait 2 seconds and restart mako
sleep 2
killall mako
mako &
