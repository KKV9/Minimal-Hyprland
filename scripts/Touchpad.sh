#!/bin/bash
## Touchpad 🖱️##

# Enable/Disable touchpad

STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

enable_touchpad() {
    # Write state to status file 
    printf "true" >"$STATUS_FILE"
    # Notify state
    notify-send -u low -i "input-touchpad" "Touchpad enabled"
    # Change hyprland variable state
    hyprctl keyword '$TOUCHPAD_ENABLED' "true" -r
}

disable_touchpad() {
    printf "false" >"$STATUS_FILE"
    notify-send -u low -i "input-touchpad" "Touchpad disabled"
    hyprctl keyword '$TOUCHPAD_ENABLED' "false" -r
}

if ! [ -f "$STATUS_FILE" ]; then
  # Disable if not status file is found
  disable_touchpad
else
  # Find status file state and toggle state
  if [ "$(cat "$STATUS_FILE")" == "true" ]; then
    disable_touchpad
  elif [ "$(cat "$STATUS_FILE")" == "false" ]; then
    enable_touchpad
  fi
fi
