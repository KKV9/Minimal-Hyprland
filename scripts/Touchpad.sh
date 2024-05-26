#!/bin/bash
## Touchpad 🖱️##

# Enable/Disable touchpad

# Path to the configuration file
CONFIG_FILE="$HOME/.config/hypr/user_configs/Touchpad.conf"

# Read the current value of 'enabled' from the config file
current_status=$(grep -oP '(?<=enabled = )\w+' "$CONFIG_FILE")

# Toggle the value (true -> false, false -> true)
if [[ "$current_status" == "true" ]]; then
  new_status="false"
  prompt="Touchpad Diabled"
else
  new_status="true"
  prompt="Touchpad Enabled"
fi

# Update the config file with the new value
sed -i \
  "s/enabled = $current_status/enabled = $new_status/" \
  "$CONFIG_FILE"

notify-send -u low -i "input-touchpad" "$prompt"
