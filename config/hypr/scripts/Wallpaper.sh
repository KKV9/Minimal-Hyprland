#!/bin/bash
## Wallpaper Chooser ##

# Call yazi to select a file and set it as the current wallpaper

SCRIPTSDIR="$HOME/.config/hypr/scripts"
PNG=$HOME/.cache/current_wallpaper.png

# Store yazi output in tempfile
tmp=$(mktemp)
kitty -e yazi "$HOME/Pictures/Wallpapers/" --chooser-file "$tmp"

# Last selected file is stored in a variable
newWallpaper="$(tail -1 "$tmp")"

# Check if no file is selected
if ! [ -s "$tmp" ]; then
  rm "$tmp"
  exit 0
fi

# Remove temporary file
rm "$tmp"

# Set wallpaper with waybg
killall wbg
wbg "$newWallpaper" &

# Hyprlock only supports pngs
if [[ $newWallpaper == *.png ]]; then
	# Copy to cache to be read by hyprlock
	cp -f "$newWallpaper" "$PNG"
else
	# Convert to png if not correct format
	notify-send -u "low" -i emblem-system "Converting image to png..."
	magick "$newWallpaper" "$PNG"
fi

# Call refresh script
"$SCRIPTSDIR"/Refresh.sh
