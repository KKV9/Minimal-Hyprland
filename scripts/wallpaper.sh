#!/bin/sh
## Wallpaper 🖥️##

# Call yazi/fzf to select a file and set it as the current wallpaper

PNG=$HOME/.cache/current_wallpaper.png

# Store yazi/fzf output in tempfile
tmp=$(mktemp)

case "$SHELL" in
*/fish)
  cd "$HOME/Pictures/Wallpapers/" || exit 1
  if which kitty >/dev/null; then
    kitty --class "floating" --title "Wallpaper select" -- fzf.fish "$tmp"
  elif which foot >/dev/null; then
    foot --app-id="floating" --title="Wallpaper select" -- fzf.fish "$tmp"
  fi
  ;;
*)
  # Fallback
  $TERMINAL -e yazi "$HOME/Pictures/Wallpapers/" --chooser-file "$tmp"
  ;;
esac

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
