#!/bin/bash
## Copy configs ##

# Define directory for user configuration
USERCONFIGS="$HOME/.config/hypr/user_configs"

# Gnereate home folders
cp -f config/user-dirs.dirs "$HOME"/.config/
xdg-user-dirs-update

# If user is installing from scratch
if [ ! -f "$USERCONFIGS/Overrides.conf" ]; then
  # Copy the overrides configuration
  mkdir -p "$USERCONFIGS"
  cp -rf "user_configs/Overrides.conf" "$USERCONFIGS/"

  # Make folders to store downloaded cursor theme and wallpapers
  mkdir -p icons
  mkdir -p wallpapers

  # Download wallpapers
  echo "Downloading wallpapers..."
  wget "https://raw.githubusercontent.com/antoniosarosi/Wallpapers/master/52.png"

  # Download pywal extention
  echo "Downloading themes..."
  git clone https://github.com/makman12/pywalQute.git config/qutebrowser/pywalQute

  # Download cursor theme
  echo "Downloading icons..."
  wget "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz"

  # Extract cursors
  echo "Extracting archives..."
  tar -xf Bibata-Modern-Classic.tar.xz -C icons/
  rm Bibata-Modern-Classic.tar.xz

  # Copy downloaded icons and wallpapers
  mv "52.png" wallpapers/wallpaper.png
  sudo cp -rf icons/* "/usr/share/icons/"
  cp -rf wallpapers/* "$HOME/Pictures/Wallpapers/"
  cp -rf "wallpapers/wallpaper.png" "$HOME/.cache/current_wallpaper.png"

  # Run pywal
  echo "Creating color pallette..."
  wal -i "$HOME/.cache/current_wallpaper.png" -s -t -n -e >/dev/null
fi

# Copy remaining config files
cp -rf ".gtkrc-2.0" "$HOME/"
cp -rf config/* "$HOME/.config/"
cp -rf themes/* "$HOME/.local/share/themes/"
cp -rf applications/* "$HOME/.local/share/applications/"
# Create symlinks for qtgtk
mkdir -p "$HOME/.themes"
ln -sf ~/.local/share/themes/wall-gtk/ ~/.themes/

# Refresh hyprland if it is running
echo "Copying done!"
if [ "$XDG_SESSION_DESKTOP" == "Hyprland" ]; then
  sleep 0.5
  "$HOME"/.config/hypr/scripts/Refresh.sh
fi
