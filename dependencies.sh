#!/bin/bash
## Dependency list ##

# Function for installing packages
install_package_pacman() {
  # Checking if package is already installed
  if pacman -Q "$1" &>/dev/null; then
    echo "$1 is already installed. Skipping..."
  else
    # Package not installed
    echo "Installing $1 ..."
    sudo pacman -S --noconfirm --needed "$1"
    # Making sure package is installed
    if pacman -Q "$1" &>/dev/null; then
      echo "$1 was installed."
    else
      # Something is missing, exiting.
      echo "$1 failed to install. You may need to install manually."
      exit 1
    fi
  fi
}

# Function for installing packages
install_package() {
  # Checking if package is already installed
  if $aurHelper -Q "$1" &>>/dev/null; then
    echo "$1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    $aurHelper -S --noconfirm --needed "$1"
    # Making sure package is installed
    if $aurHelper -Q "$1" &>>/dev/null; then
      echo "$1 was installed."
    else
      # Something is missing, exiting to review log
      echo "$1 failed to install, You may need to install manually!"
      exit 1
    fi
  fi
}

# List of packages to setup aur helper
base=(
  base-devel
  rustup
  git
  wget
  curl
  fzf
)

packages=(
  cliphist
  hyprlock
  imagemagick
  kitty
  pamixer
  pavucontrol
  pipewire-alsa
  playerctl
  lxqt-policykit
  qutebrowser
  qt6-svg
  qt5-styleplugins
  qt6gtk2
  qt6-wayland
  qt5-wayland
  fuzzel
  mako
  wbg
  python-pywal
  waybar
  wl-clipboard
  xdg-user-dirs
  xdg-utils
  mpv
  mpv-mpris
  pacman-contrib
  neovim
  yazi-git
  noto-fonts-emoji
  ttf-font-awesome
  ttf-jetbrains-mono-nerd
  ttf-nerd-fonts-symbols
  ttf-nerd-fonts-symbols-common
  adobe-source-code-pro-fonts
  unzip
  nodejs
  gtk-engine-murrine
  hyprland
  hyprcursor
  hyprpicker
  hyprlang
  pipewire
  wireplumber
  pipewire-audio
  pipewire-alsa
  pipewire-pulse
  ffmpegthumbnailer
  xdg-desktop-portal
  xdg-desktop-portal-hyprland
  fish
  tela-icon-theme-bin
  python-adblock
  kitty-shell-integration
  kitty-terminfo
  imagemagick
  gsettings-desktop-schemas
  gtk2
  gtk3
  unarchiver
  zoxide
  tree-sitter
  tree-sitter-bash
  tree-sitter-c
  tree-sitter-lua
  tree-sitter-markdown
  tree-sitter-python
  tree-sitter-query
  tree-sitter-vimdoc
  grimblast-git
  satty-bin
)

sddm=(
  sddm-git
  qt6-svg
  qt6-declarative
  layer-shell-qt
  layer-shell-qt5
)

echo "Editing pacman.conf ..."
pacman_conf="/etc/pacman.conf"

# Remove comments '#' from specific lines
lines_to_edit=(
  "Color"
  "CheckSpace"
  "VerbosePkgLists"
  "ParallelDownloads"
)

# Uncomment specified lines if they are commented out
for line in "${lines_to_edit[@]}"; do
  if grep -q "^#$line" "$pacman_conf"; then
    sudo sed -i "s/^#$line/$line/" "$pacman_conf"
    echo "Uncommented: $line"
  else
    echo "$line is already uncommented."
  fi
done

# Add "ILoveCandy" below ParallelDownloads if it doesn't exist
if grep -q "^ParallelDownloads" "$pacman_conf" && ! grep -q "^ILoveCandy" "$pacman_conf"; then
  sudo sed -i "/^ParallelDownloads/a ILoveCandy" "$pacman_conf"
  echo "Added ILoveCandy below ParallelDownloads."
else
  echo "ILoveCandy already exists"
fi

echo "Pacman.conf edited"

# updating pacman.conf
sudo pacman -Sy

for pkg in "${base[@]}"; do
  install_package_pacman "$pkg"
done

# Setup rustup
echo "Setting up rust..."
rustup default stable || {
  echo "Failed to install rustup toolchain"
  exit 1
}

# Find aur helper
aurHelper=$(command -v yay || command -v paru)

if [ -n "$aurHelper" ]; then
  echo "AUR helper already installed."
else
  # Install paru if no aur helper is found
  echo "AUR helper was NOT located"
  echo "Installing paru from AUR"
  git clone https://aur.archlinux.org/paru-bin.git || {
    echo "Failed to clone paru from AUR"
    exit 1
  }
  cd paru-bin || {
    echo "Failed to enter paru-bin directory"
    exit 1
  }
  makepkg -si --noconfirm || {
    echo "Failed to install paru from AUR"
    exit 1
  }
  aurHelper=$(command -v yay || command -v paru)
  cd ..
fi

# Update system before proceeding
echo "Performing a full system update to avoid issues...."
$aurHelper -Syu --noconfirm || {
  echo "Failed to update system"
  exit 1
}

for package in "${packages[@]}"; do
  install_package "$package"
  [ $? -ne 0 ] && {
    echo "$package Package installation failed"
    exit 1
  }
done

if [ "$1" == "sddm" ]; then
  for package in "${sddm[@]}"; do
    install_package "$package"
    [ $? -ne 0 ] && {
      echo "$package Package installation failed"
      exit 1
    }
  done
  sudo systemctl enable sddm
  chmod +x sddm.sh && ./sddm.sh
fi

echo "Activating pipewire services..."
systemctl --user enable pipewire.socket pipewire-pulse.socket wireplumber.service
systemctl --user enable pipewire.service
