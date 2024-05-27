#!/bin/bash
## Functions ##

# Constants
export USER_CONFIGS="$HOME/.config/hypr/user_configs"
export USER_CONFIG="$USER_CONFIGS/overrides.conf"
OVERRIDES="user_configs/overrides.conf"
DEFAULT_LAYOUT="us"

# Fuction for prompting yes or no questions
ask_yn() {
  while true; do
    read -rp "$1 [y/n]: " confirm
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
  if "$2" -Q "$1" &>>/dev/null; then
    echo "$1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    "$2" -S --noconfirm --needed "$1"
    # Making sure package is installed
    if "$2" -Q "$1" &>>/dev/null; then
      echo "$1 was installed."
    else
      # Something is missing, exiting to review log
      echo "$1 failed to install, You may need to install manually!"
      exit 1
    fi
  fi
}

# Detect keyboard layout using localectl or setxkbmap
detect_layout() {
  if command -v localectl >/dev/null 2>&1; then
    layout=$(localectl status --no-pager | awk '/X11 Layout/ {print $3}')
    if [ -n "$layout" ]; then
      echo "$layout"
    else
      echo $DEFAULT_LAYOUT
    fi
  elif command -v setxkbmap >/dev/null 2>&1; then
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
  while true; do
    read -rp "Press Enter to continue..."
    if [ "$1" == "list-x11-keymap-variants" ]; then
      return_string=$(localectl "$1" "$3" | fzf)
    else
      return_string=$(localectl "$1" | fzf)
    fi

    # Set a default value if null
    if ! [ "$return_string" ]; then
      return_string=$2
    fi
    echo "You selected $return_string" >&2
    if ask_yn "Is this correct?"; then
      break
    else
      echo "Try again..." >&2
    fi
  done
  echo "$return_string"
}

# Set caps lock options with y/n prompt
manual_caps() {
  if ask_yn "Swap caps and escape?"; then
    echo "caps:swapescape"
  else
    echo "caps:escape"
  fi
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
