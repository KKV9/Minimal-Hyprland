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
packages="hyprlock imagemagick foot pulsemixer lxqt-policykit qutebrowser qt6-wayland qt5-wayland fuzzel mako wbg python-pywal waybar wl-clipboard cliphist xdg-user-dirs xdg-utils mpv-mpris neovim yazi noto-fonts-emoji ttf-font-awesome ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols unzip nodejs gtk-engine-murrine hyprcursor hyprpicker hyprlang wireplumber pipewire-audio pipewire-alsa pipewire-pulse ffmpegthumbnailer xdg-desktop-portal-hyprland fish tela-icon-theme-bin python-adblock gsettings-desktop-schemas zoxide grimblast-git satty-bin libnotify pkgfile npm brightnessctl ripgrep fd bat less networkmanager-dmenu-git btop swayimg handlr-regex sound-theme-freedesktop ytfzf socat hyprland bibata-cursor-theme-bin"
# Full package install list
install_list="$packages"

# Setup pacman
pacman_config

# Install base packages
for pkg in $base; do
	sudo pacman -S "$pkg" --needed --noconfirm
done

# Setup rustup
echo "Setting up rust..."
rustup default stable

# Find aur helper
aurHelper=$(command -v yay || command -v paru)

if [ -n "$aurHelper" ]; then
	echo "AUR helper already installed."
else
	# Install paru if no aur helper is found
	install_paru && aurHelper=$(command -v paru)
fi

# Update system before proceeding
echo "Performing a full system update to avoid issues...."
$aurHelper -Syu --noconfirm

# Add sddm dependencies to install_list
if [ "$1" = "true" ]; then
	install_list=$install_list" "$sddm
fi

# Add bluetooth dependencies to install_list
if [ "$2" = "true" ]; then
	install_list=$install_list" "$bluetooth
fi

# Install all dependencies using aur helper
for package in $install_list; do
	"$aurHelper" -S "$package" --needed --noconfirm
done

if [ "$1" = "true" ]; then
	# Enable sddm service
	sudo systemctl enable sddm
	# Setup sddm theme
	./install_scripts/sddm.sh
fi

if [ "$2" = "true" ]; then
	# Enable bluetooth service
	sudo systemctl enable bluetooth
fi

echo "Activating pipewire services..."
sudo systemctl enable pipewire.socket pipewire-pulse.socket wireplumber.service pipewire.service
sudo pkgfile --update
