#!/bin/bash
## Copy configs ##

# Check if the directory is correct
if [ ! -f install.sh ]; then
  cd ..
  if [ ! -f install.sh ]; then
    echo "File not found: install.sh"
    echo "Please download the full repo!"
    exit 1
  fi
fi

source install_scripts/functions.sh

# Generate home folders
mkdir -p "$HOME"/.config
cp -f config/user-dirs.dirs "$HOME"/.config/
xdg-user-dirs-update

# If user is installing from scratch
if [ ! -f "$USERCONFIG" ]; then
  # Copy the overrides configuration
  mkdir -p "$USERCONFIGS"
  cp -f "$OVERRIDES" "$USERCONFIG"
  mkdir -p "$HOME"/.local/share/themes
  mkdir -p "$HOME"/.local/share/applications
  mkdir -p "$HOME"/.themes

  # Make folders to store downloaded themes and wallpapers
  mkdir -p icons
  mkdir -p wallpapers
  mkdir -p themes

  # Download wallpapers
  echo "Downloading wallpapers..."
  wget "https://raw.githubusercontent.com/antoniosarosi/Wallpapers/master/52.png"
  echo "Downloading themes..."
  # Download pywal extention
  git clone https://github.com/makman12/pywalQute.git config/qutebrowser/pywalQute
  # Download gtk theme
  git clone https://github.com/deviantfero/wpgtk-templates
  # Download cursor theme
  echo "Downloading icons..."
  wget "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz"

  # Extract cursors
  echo "Extracting archives..."
  tar -xf Bibata-Modern-Classic.tar.xz -C icons/
  # Cleanup
  rm Bibata-Modern-Classic.tar.xz

  echo "Setting up themes..."
  # Move downloaded wallpaper to wallpaper folder
  mv "52.png" wallpapers/wallpaper.png
  # Setup gtk theme
  mv wpgtk-templates/linea-nord-color/ themes/wall-gtk/
  rm themes/wall-gtk/general/dark.css themes/wall-gtk/gtk-2.0/gtkrc
  ln -sf ../../../../../.cache/wal/gtk2.base themes/wall-gtk/gtk-2.0/gtkrc
  ln -sf ../../../../../.cache/wal/wall-gtk.base.css themes/wall-gtk/general/dark.css
  # Cleanup
  rm -rf wpgtk-templates/

  echo "Installing themes..."
  sudo cp -rf icons/* "/usr/share/icons/"
  cp -rf themes/* "$HOME/.local/share/themes/"
  cp -rf wallpapers/* "$HOME/Pictures/Wallpapers/"
  cp -rf "wallpapers/wallpaper.png" "$HOME/.cache/current_wallpaper.png"

  # Run pywal
  echo "Creating color pallette..."
  wal -i "$HOME/.cache/current_wallpaper.png" -s -t -n -e >/dev/null
fi

# Copy remaining config files
cp -rf ".gtkrc-2.0" "$HOME/"
cp -rf config/* "$HOME/.config/"
chmod +x "$HOME"/.config/hypr/scripts/* # Ensure scripts are executable
cp -rf applications/* "$HOME/.local/share/applications/"
# Create symlinks for qtgtk
ln -sf ~/.local/share/themes/wall-gtk/ ~/.themes/

# Refresh hyprland if it is running
echo "Copying done!"
if [ "$XDG_SESSION_DESKTOP" == "Hyprland" ]; then
  sleep 0.5
  "$HOME"/.config/hypr/scripts/Refresh.sh
fi
