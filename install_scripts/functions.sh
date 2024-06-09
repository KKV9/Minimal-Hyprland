#!/bin/sh
## Functions ##

# Constants
export USER_CONFIGS="$HOME/.config/hypr/user_configs"
export USER_CONFIG="$USER_CONFIGS/overrides.conf"
export DEFAULT_LAYOUT="us"
OVERRIDES="user_configs/overrides.conf"

# Fuction for prompting yes or no questions
ask_yn() {
  while true; do
    printf "%s [y/n]: " "$1" >&2
    read -r confirm
    case $confirm in
    [yY])
      return 0
      ;;
    [nN])
      return 1
      ;;
    *)
      echo "Please enter either 'y' or 'n'."
      ;;
    esac
  done
}

# Detect keyboard layout using localectl or setxkbmap
detect_layout() {
  if which localectl >/dev/null 2>&1; then
    layout=$(localectl status --no-pager | awk '/X11 Layout/ {print $3}')
    if [ -n "$layout" ]; then
      echo "$layout"
    else
      echo $DEFAULT_LAYOUT
    fi
  elif which setxkbmap >/dev/null 2>&1; then
    layout=$(setxkbmap -query | grep layout | awk '{print $2}')
    if [ -n "$layout" ]; then
      echo "$layout"
    else
      echo $DEFAULT_LAYOUT
    fi
  else
    echo $DEFAULT_LAYOUT
  fi
}

# Set keyboard settings with fzf
manual_keys() {
  echo "Select an option from the following screen" >&2
    printf "Press enter to continue..." >&2
    read -r confirm
    if [ "$1" = "list-x11-keymap-variants" ]; then
      return_string=$(localectl "$1" "$3" | fzf)
    else
      return_string=$(localectl "$1" | fzf)
    fi

    # Set a default value if null
    if ! [ "$return_string" ]; then
      return_string=$2
    fi
    echo "You selected $return_string" >&2
  echo "$return_string"
}

# Replace keyboard options in Devices.conf
set_opts() {
  if [ "$1" ]; then
    printf "\nYou selected %s: %s\n" "$2" "$1" # Create newline char
    sed -i "s/\(kb_$2 = \).*/\1$1/" "$OVERRIDES"
    sed -i "s/\(kb_$2 = \).*/\1$1/" "sddm/hyprland.conf" # Change layout for sddm
  else
    printf "\nYou selected %s: default\n" "$2"
    sed -i "s/\(kb_$2 = \).*/\1$3/" "$OVERRIDES"
    sed -i "s/\(kb_$2 = \).*/\1$3/" "sddm/hyprland.conf" # Change layout for sddm defaults
  fi
}

# Spruce up pacman configuration
pacman_config() {
  echo "Editing pacman.conf ..."
  pacman_conf="/etc/pacman.conf"

  # Remove comments '#' from specific lines
  lines_to_edit="Color CheckSpace VerbosePkgLists ParallelDownloads"

  # Uncomment specified lines if they are commented out
  for line in $lines_to_edit; do
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
}

install_paru() {
  echo "AUR helper was NOT located" >&2
  echo "Installing paru from AUR" >&2
  git clone https://aur.archlinux.org/paru-bin.git || {
    echo "Failed to clone paru from AUR" >&2
    return 1
  }
  cd paru-bin || {
    echo "Failed to enter paru-bin directory" >&2
    return 1
  }
  makepkg -si --noconfirm || {
    echo "Failed to install paru from AUR" >&2
    return 1
  }
  cd ..
}
