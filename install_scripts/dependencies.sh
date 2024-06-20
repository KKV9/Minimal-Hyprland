#!/bin/sh
## Dependency list ##

. install_scripts/functions.sh || . functions.sh # Find the functions file to reference

# List of base packages
base="base-devel rustup git wget curl fzf"
# List of sddm dependencies
sddm="sddm qt6-svg qt6-declarative layer-shell-qt layer-shell-qt5"
# List of bluetooth packages
bluetooth="bluez bluez-utils bluetuith"
# List of packages installed with aur helper
packages="hyprlock imagemagick foot pulsemixer lxqt-policykit qutebrowser qt6-wayland qt5-wayland fuzzel mako wbg python-pywal waybar wl-clipboard cliphist xdg-user-dirs xdg-utils mpv-mpris neovim yazi-git noto-fonts-emoji ttf-font-awesome ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols unzip nodejs gtk-engine-murrine hyprland hyprcursor hyprpicker hyprlang wireplumber pipewire-audio pipewire-alsa pipewire-pulse ffmpegthumbnailer xdg-desktop-portal-hyprland fish tela-icon-theme-bin python-adblock gsettings-desktop-schemas unarchiver zoxide grimblast-git satty-bin libnotify pkgfile npm brightnessctl ripgrep fd bat less networkmanager-dmenu-git"

# Setup pacman
pacman_config

# Install base packages
for pkg in $base; do
	sudo pacman -S "$pkg" --needed --noconfirm ||
		echo "$package Package installation failed" && exit 1
done

# Setup rustup
echo "Setting up rust..."
if ! rustup default stable; then
	echo "Failed to install rustup toolchain"
	exit 1
fi

# Find aur helper
aurHelper=$(command -v yay || command -v paru)

if [ -n "$aurHelper" ]; then
	echo "AUR helper already installed."
else
	# Install paru if no aur helper is found
	if ! install_paru; then
		exit 1
	fi
	aurHelper=$(command -v paru)
fi

# Update system before proceeding
echo "Performing a full system update to avoid issues...."
if ! $aurHelper -Syu --noconfirm; then
	echo "Failed to update system"
	exit 1
fi

# Install all dependencies using aur helper
for package in $packages; do
	"$aurHelper" -S "$package" --needed --noconfirm ||
		echo "$package Package installation failed" && exit 1
done

# Install sddm using aur helper if chosen
if [ "$1" = True ]; then
	for package in $sddm; do
		"$aurHelper" -S "$package" --needed --noconfirm ||
			echo "$package Package installation failed" && exit 1
	done
	# Enable sddm service
	sudo systemctl enable sddm
	# Setup sddm theme
	./install_scripts/sddm.sh
fi

# Install bluetooth using aur helper if chosen
if [ "$2" = True ]; then
	for package in $bluetooth; do
		"$aurHelper" -S "$package" --needed --noconfirm ||
			echo "$package Package installation failed" && exit 1
	done
	# Enable bluetooth service
	sudo systemctl enable bluetooth
fi

echo "Activating pipewire services..."
sudo systemctl enable pipewire.socket pipewire-pulse.socket wireplumber.service
sudo systemctl enable pipewire.service
sudo pkgfile --update
