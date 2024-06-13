#!/bin/sh
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

. install_scripts/functions.sh

# Generate home folders
mkdir -p "$HOME"/.config
mkdir -p "$HOME"/.config/bat
mkdir -p "$HOME"/.config/qutebrowser/permissions
mkdir -p "$HOME"/.local/bin
mkdir -p "$HOME"/.local/share/dots
cp -f config/user-dirs.dirs "$HOME"/.config/
rm -rf "$HOME"/go/

# If user is installing from scratch
if [ ! -f "$USER_CONFIG" ]; then
	# Copy the overrides configuration
	mkdir -p "$USER_CONFIGS"
	cp -f user_configs/* "$USER_CONFIGS/"
	mkdir -p "$HOME"/.local/share/themes
	mkdir -p "$HOME"/.local/share/applications
	mkdir -p "$HOME"/.themes
	mkdir -p "$HOME"/Pictures/Wallpapers
	mkdir -p "$HOME"/Pictures/Screenshots

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

	# Install greasemonkey extentions
	mkdir -p config/qutebrowser/greasemonkey
	wget https://update.greasyfork.org/scripts/32626/Disable%20YouTube%20Video%20Ads.user.js -O config/qutebrowser/greasemonkey/yt-skip-ads.js

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

	echo "Preparing themes..."
	# Move downloaded wallpaper to wallpaper folder
	mv "52.png" wallpapers/wallpaper.png
	# Setup gtk theme
	mv wpgtk-templates/linea-nord-color/ themes/wall-gtk/
	mv wpgtk-templates/FlatColor/gtk-3.20/ themes/wall-gtk/gtk-3.20/
	rm themes/wall-gtk/general/dark.css themes/wall-gtk/gtk-2.0/gtkrc
	ln -sf ../../../../../.cache/wal/gtk2.base themes/wall-gtk/gtk-2.0/gtkrc
	ln -sf ../../../../../.cache/wal/gtk3.base.css themes/wall-gtk/gtk-3.20/gtk.css
	ln -sf ../../../../../.cache/wal/gtk4.base.css themes/wall-gtk/general/dark.css
	# Cleanup
	rm -rf wpgtk-templates/

	echo "Installing themes..."
	sudo cp -rf icons/* "/usr/share/icons/"
	cp -rf themes/* "$HOME/.local/share/themes/"
	cp -rf wallpapers/* "$HOME/Pictures/Wallpapers/"
	cp -rf "wallpapers/wallpaper.png" "$HOME/.cache/current_wallpaper.png"

	touch "$HOME"/.config/INITIAL_BOOT
fi

# Copy remaining config files
echo "Copying files..."
cp -rf config/* "$HOME/.config/"
cp -rf scripts/* "$HOME/.local/bin/"
cp -rf data/* "$HOME/.local/share/dots/"
cp -rf applications/* "$HOME/.local/share/applications/"

# Allow satty to save screenshots
if [ ! -f "$HOME/.config/satty/config.toml" ]; then
	mkdir -p "$HOME/.config/satty"
	echo '[general]' >"$HOME/.config/satty/config.toml"
	echo 'output-filename = "Pictures/Screenshots/satty-%Y-%m-%d_%H:%M:%S.png"' >>"$HOME/.config/satty/config.toml"
fi

if [ ! -f "$HOME/.config/bat/config" ]; then
	echo '--map-syntax "*.conf:INI"' >"$HOME/.config/bat/config"
fi

# Surpress errors by creating overrides if it doesn't exist
if [ ! -f "$HOME/.config/qutebrowser/overrides.py" ]; then
	touch "$HOME/.config/qutebrowser/overrides.py"
	touch "$HOME/.config/qutebrowser/permissions/cookies"
	touch "$HOME/.config/qutebrowser/permissions/clipboard"
fi

# Ensure scripts are executable
chmod +x "$HOME"/.local/bin/*

# Run pywal
echo "Creating color pallette..."
wal -i "$HOME/.cache/current_wallpaper.png" -s -t -n -e >/dev/null

# Create symlinks for qtgtk
ln -sf ~/.local/share/themes/wall-gtk/ ~/.themes/

# Refresh hyprland if it is running
echo "Copying done!"
if [ "$XDG_SESSION_DESKTOP" = "Hyprland" ]; then
	sleep 0.5
	"$HOME"/.local/bin/refresh.sh
fi
