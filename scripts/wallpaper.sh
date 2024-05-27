#!/bin/bash
## Wallpaper 🖥️##

# Call yazi to select a file and set it as the current wallpaper

PNG=$HOME/.cache/current_wallpaper.png

# Store yazi output in tempfile
tmp=$(mktemp)
kitty --class "floating" --title "Wallpaper select" -- yazi "$HOME/Pictures/Wallpapers/" --chooser-file "$tmp"

# Last selected file is stored in a variable
new_wallpaper="$(tail -1 "$tmp")"

# Check if no file is selected
if ! [ -s "$tmp" ]; then
  rm "$tmp"
  exit 0
fi

# Remove temporary file
rm "$tmp"

# Set wallpaper with waybg
killall wbg
wbg "$new_wallpaper" &

# Hyprlock only supports pngs
if [[ $new_wallpaper == *.png ]]; then
  # Copy to cache to be read by hyprlock
  cp -f "$new_wallpaper" "$PNG"
else
  # Convert to png if not correct format
  notify-send -u "low" -i emblem-system "Converting image to png..."
  magick "$new_wallpaper" "$PNG"
fi

# Call refresh script
refresh.sh
