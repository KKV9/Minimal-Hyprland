#!/bin/sh
## Dependency list ##

. install_scripts/functions.sh || . functions.sh # Find the functions file to reference

# List of base packages
base="base-devel rustup git wget curl fzf"
# List of sddm dependencies
sddm="sddm qt6-svg qt6-declarative layer-shell-qt layer-shell-qt5"
# List of packages installed with aur helper
packages="hyprlock imagemagick foot foot-terminfo pavucontrol lxqt-policykit qutebrowser qt5-styleplugins qt6gtk2 qt6-wayland qt5-wayland fuzzel mako wbg python-pywal waybar wl-clipboard cliphist xdg-user-dirs xdg-utils mpv-mpris pacman-contrib neovim yazi-git noto-fonts-emoji ttf-font-awesome ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols unzip nodejs gtk-engine-murrine hyprland hyprcursor hyprpicker hyprlang wireplumber pipewire-audio pipewire-alsa pipewire-pulse ffmpegthumbnailer xdg-desktop-portal-hyprland fish tela-icon-theme-bin python-adblock imagemagick gsettings-desktop-schemas unarchiver zoxide grimblast-git satty-bin libnotify pkgfile npm brightnessctl ripgrep fd bat less"

# Setup pacman
pacman_config

# Install base packages
for pkg in $base; do
  if ! sudo pacman -S "$pkg" --needed --noconfirm; then
    echo "$package Package installation failed"
    exit 1
  fi
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
  if ! "$aurHelper" -S "$package" --needed --noconfirm; then
    echo "$package Package installation failed"
    exit 1
  fi
done

# Install sddm using aur helper if chosen
if [ "$1" = "sddm" ]; then
  for package in $sddm; do
    if ! "$aurHelper" -S "$package" --needed --noconfirm; then
      echo "$package Package installation failed"
      exit 1
    fi
  done
  sudo systemctl enable sddm
  ./install_scripts/sddm.sh
fi

echo "Activating pipewire services..."
systemctl --user enable pipewire.socket pipewire-pulse.socket wireplumber.service
systemctl --user enable pipewire.service
sudo pkgfile --update
