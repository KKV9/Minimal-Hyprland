#!/bin/sh
## Action menu ❗##

# Fuzzel prompt for performing various tasks

# Define JSON file
config="$HOME/.local/share/dots/actions.json"

# Get default monitor settings for projector menu
get_monitor_settings() {
  # Search for user prefernces in overrides directory
  settings=$(cat "$HOME"/.config/hypr/user_configs/*.conf |
    grep -e "monitor*.=*.$1" |
    grep -v '^ *#' | awk -F '=' 'gsub (" ", "") $2; {print $2}' |
    awk -F '#' '{print $1}' | tail -1)

  if [ -n "$settings" ]; then
    # If monitor preferences are found, use them
    echo "$settings"
  else
    # If monitor preferences are not found, use defaults
    echo "$1,highrr,auto,1"
  fi
}

# Function to load values from JSON
load_from_json() {
  # Read values into string for corresponding menu
  prompt=$(jq -r ".$1.prompt" <"$config")
  opts=$(jq -r ".$1.opts[]" <"$config")
  icons=$(jq -r ".$1.icons[]" <"$config")
  commands=$(jq -r ".$1.commands[]" <"$config")

  # Use a while loop to read each line from opts and icons
  while IFS= read -r opt && IFS= read -r icon <&3; do
    option="${opt}\0icon\037${icon}\n"
    combined_string="$combined_string$option"
  done <<EOF 3<<EOF2
$opts
EOF
$icons
EOF2
echo "$combined_string"
}

# Check for external monitor
if [ "$1" = "projector" ] && ! hyprctl monitors all | grep -e "HDMI-A-1" && ! hyprctl monitors all | grep -e "HDMI-A-1"; then
  # Exit when no external display found
  notify-send -u low -i "computer" "Projector menu" "No external monitor found"
  exit 0
fi

# Load data from json file
load_from_json "$1"

# Menu prompt
selection=$(printf "%b" "$combined_string" | $MENU -d --index --width 45 --lines 18 -p "$prompt")

# Check if something was selected
if [ -n "$selection" ]; then
  # Increment index number for sed line numbers
  selection=$((selection + 1))
  # Execute the corresponding command
  eval "$(echo "$commands" | sed "${selection}q;d")"
fi
