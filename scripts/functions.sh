#!/bin/sh
## Functions ❓ ##

# Extra functions for actions.sh script

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

# Check for external monitor
if [ "$1" = "projector" ] && ! hyprctl monitors all | grep -e "HDMI-A-1" && ! hyprctl monitors all | grep -e "HDMI-A-1"; then
	# Exit when no external display found
	notify-send -u low -i "computer" "Projector menu" "No external monitor found"
	exit 0
fi
