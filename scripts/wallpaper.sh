#!/bin/sh
## Wallpaper 🖥️##

# Call yazi/fzf to select a file and set it as the current wallpaper

PNG=$HOME/.cache/current_wallpaper.png

# Store yazi/fzf output in tempfile
tmp=$(mktemp)

cd "$HOME/Pictures/Wallpapers/" || exit 1
if [ "$TERMINAL" = "foot" ]; then
	$TERMINAL --app-id="floating" --title="Wallpaper select" -e fzf.sh "$tmp"
else
	$TERMINAL --app-id="floating" --title="Wallpaper select" -e yazi "$HOME/Pictures/Wallpapers/" --chooser-file "$tmp" \
    || $TERMINAL -e yazi "$HOME/Pictures/Wallpapers/" --chooser-file "$tmp"
fi

# Last selected file is stored in a variable
new_wallpaper="$(tail -1 "$tmp")"

# Check if no file is selected
if ! [ -e "$new_wallpaper" ]; then
	rm "$tmp"
	exit 0
fi

# Remove temporary file
rm "$tmp"

# Set wallpaper with waybg
killall wbg
wbg "$new_wallpaper" &

# Hyprlock only supports pngs
case "$new_wallpaper" in
*.png)
	cp -f "$new_wallpaper" "$PNG"
	;;
*)
	notify-send -u "low" -i emblem-system "Converting image to png..."
	magick "$new_wallpaper" "$PNG"
	;;
esac

# Call refresh script
refresh.sh
