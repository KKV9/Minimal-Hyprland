#!/bin/bash
## Copy configs ##

# Create folders
mkdir -p icons
mkdir -p wallpapers
xdg-user-dirs-update

echo "Downloading wallpapers..."
wget "https://raw.githubusercontent.com/antoniosarosi/Wallpapers/master/52.png" && mv "52.png" wallpapers/wallpaper.png

echo "Downloading themes..."
git clone https://github.com/makman12/pywalQute.git config/qutebrowser/pywalQute

echo "Downloading icons..."
wget "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz"

# Extract themes
tar -xf Bibata-Modern-Classic.tar.xz -C icons/
rm Bibata-Modern-Classic.tar.xf

echo "Copying config..."
cp -rf ".gtkrc-2.0" "$HOME/"
cp -rf "config/*" "$HOME/.config/"
cp -rf "themes/*" "$HOME/.local/share/themes/"
cp -rf "icons/*" "$HOME/.local/share/icons/"
cp -rf "icons/*" "$HOME/.local/share/icons/"
cp -rf "applications/*" "$HOME/.local/share/applications/"
cp -rf "wallpapers/*" "$HOME/Pictures/Wallpapers/"
cp -rf "wallpapers/wallpaper.png" "$HOME/.cache/current_wallpaper.png"

echo "Creating symlinks..."
mkdir -p "$HOME/.themes"
ln -sf ~/.local/share/themes/wall-gtk/ ~/.themes/

# Run pywal
echo "Creating color pallette..."
wal -i "$HOME/.cache/current_wallpaper.png" -s -t -n -e >/dev/null
