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

refresh_album_art() {
	# Remove old album art
	rm -f "$HOME"/.cache/current_song.png
	sleep 0.2
	# Get album art
	curl -m 3 "$(playerctl metadata --format "{{mpris:artUrl}}")" \
		>temp.jpg &&
		magick temp.jpg "$HOME"/.cache/current_song.png &&
		rm -f temp.jpg &&
		return 0 || return 1
}

toggle_loop() {
	if [ "$(playerctl loop)" = "Playlist" ]; then
		playerctl loop Track
		icon="media-playlist-repeat-song"
	elif [ "$(playerctl loop)" = "Track" ]; then
		playerctl loop None
		icon="music"
	else
		playerctl loop Playlist
		icon="media-playlist-repeat"
	fi
	notify-send -u low -i $icon "Player Menu" "Loop status: $(playerctl loop)"
}

toggle_shuffle() {
	playerctl shuffle toggle
	if [ "$(playerctl shuffle)" = "On" ]; then
		icon="media-playlist-shuffle"
	else
		icon="music"
	fi
	notify-send -u low -i $icon "Player Menu" "Shuffle status: $(playerctl shuffle)"
}

# Check for external monitor
if [ "$1" = "projector" ] && ! hyprctl monitors all | grep -e "HDMI-A-1" && ! hyprctl monitors all | grep -e "HDMI-A-1"; then
	# Exit when no external display found
	notify-send -u low -i "computer" "Projector menu" "No external monitor found"
	exit 0
fi

if [ "$1" = "player" ]; then
  if ! playerctl status; then
    notify-send -u low -i music "Player Menu" "No players found"
    exit 0
  fi
	if [ "$2" != "--no-notify" ]; then
		refresh_album_art || rm -f "$HOME"/.cache/current_song.png && notify-send -u low -i "/home/$USER/.cache/current_song.png" "Player Menu" "$(playerctl status): $(playerctl metadata --format "{{artist}} - {{title}}")"
	fi
fi
