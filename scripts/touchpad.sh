#!/bin/sh
## Touchpad 🖱️##

# Enable/Disable touchpad

STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

enable_touchpad() {
  # Write state to status file
  printf "true" >"$STATUS_FILE"
  # Notify state
  if [ "$1" = "-n" ]; then
    notify-send -u low -i "input-touchpad" "Touchpad enabled"
  fi
  # Change hyprland variable state
  hyprctl keyword "\$TOUCHPAD_ENABLED" "true" -r
}

disable_touchpad() {
  printf "false" >"$STATUS_FILE"
  if [ "$1" = "-n" ]; then
    notify-send -u low -i "input-touchpad" "Touchpad disabled"
  fi
  hyprctl keyword "\$TOUCHPAD_ENABLED" "false" -r
}

# Load states after reload
if [ "$1" = "-r" ]; then
  if ! [ -f "$STATUS_FILE" ]; then
    enable_touchpad
  else
    # Find status file state and toggle state
    if [ "$(cat "$STATUS_FILE")" = "true" ]; then
      enable_touchpad
    elif [ "$(cat "$STATUS_FILE")" = "false" ]; then
      disable_touchpad
    fi
  fi
else
  # Toggle touchpad states
  if ! [ -f "$STATUS_FILE" ]; then
    disable_touchpad "-n"
  else
    if [ "$(cat "$STATUS_FILE")" = "true" ]; then
      disable_touchpad "-n"
    elif [ "$(cat "$STATUS_FILE")" = "false" ]; then
      enable_touchpad "-n"
    fi
  fi
fi
