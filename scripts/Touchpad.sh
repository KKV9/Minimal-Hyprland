#!/bin/bash
## Touchpad 🖱️##

# Enable/Disable touchpad

STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

enable_touchpad() {
    printf "true" >"$STATUS_FILE"
    notify-send -u low -i "input-touchpad" "Touchpad enabled"
    hyprctl keyword '$TOUCHPAD_ENABLED' "true" -r
}

disable_touchpad() {
    printf "false" >"$STATUS_FILE"
    notify-send -u low -i "input-touchpad" "Touchpad disabled"
    hyprctl keyword '$TOUCHPAD_ENABLED' "false" -r
}

if ! [ -f "$STATUS_FILE" ]; then
  disable_touchpad
else
  if [ "$(cat "$STATUS_FILE")" == "true" ]; then
    disable_touchpad
  elif [ "$(cat "$STATUS_FILE")" == "false" ]; then
    enable_touchpad
  fi
fi
