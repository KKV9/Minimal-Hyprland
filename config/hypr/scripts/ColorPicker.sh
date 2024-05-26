#!/bin/bash
## Color picker 🌈##

# Hyprpicker wrapper

result=$(hyprpicker -an)

# Reload mako with picked color
killall mako
mako --border-color "$result" &
# Send notification
notify-send -u "normal" "$result Copied to clipboard"
# Wait 2 seconds and restart mako
sleep 2
killall mako
mako &
