#!/bin/sh
## Action menu ❗##

# Fuzzel prompt for performing various tasks

# Define JSON file
config="$HOME/.local/share/dots/menus/$1.json"
# Allow extra functionality
if which functions.sh; then
  . "$(which functions.sh)"
fi

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

# Load data from json file
load_from_json "$1"

# Menu prompt
selection=$(printf "%b" "$combined_string" | $MENU --dmenu --index -p "$prompt")

# Check if something was selected
if [ -n "$selection" ]; then
	# Increment index number for sed line numbers
	selection=$((selection + 1))
	# Execute the corresponding command
	eval "$(echo "$commands" | sed "${selection}q;d")"
fi
