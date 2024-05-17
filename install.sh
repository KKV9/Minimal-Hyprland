#!/bin/bash
## Install dots ##

USERCONFIG="$HOME/.config/hypr/user_configs/Overrides.conf"

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
  echo "This script should not be executed as root! Exiting......."
  exit 1
fi

echo "Welcome to the installer"
echo "ATTENTION: Please backup your configuration files before proceeding!"

while true; do
  read -rp "Would you like to proceed? [y/n] " confirm
  case $confirm in
  [yY])
    break
    ;;
  [nN])
    exit 0
    ;;
  *)
    echo "Please enter either 'y' or 'n'."
    ;;
  esac
done

while true; do
  read -rp "Install dependencies? [y/n] " confirm
  case $confirm in
  [yY])
    chmod +x dependencies.sh && ./dependencies.sh
    break
    ;;
  [nN])
    echo "No dependencies installed"
    break
    ;;
  *)
    echo "Please enter either 'y' or 'n'."
    ;;
  esac
done

if [ ! -f "$USERCONFIG" ]; then
  # Offer to change keyboard layout
  while true; do
    read -rp "Would you like to change the default keyboard layout (us)? [y/n] " confirm
    case $confirm in
    [yY])
      chmod +x keyboard_layout.sh && ./keyboard_layout.sh
      execute_script "keyboard_layout.sh"
      break
      ;;
    [nN])
      echo "Keyboard layout remains unchanged"
      break
      ;;
    *)
      echo "Please enter either 'y' or 'n'."
      ;;
    esac
  done
fi

# Copy configs
while true; do
  read -rp "Would you like to copy the config files? [y/n]" confirm
  case $confirm in
  [yY])
    chmod +x copy.sh && ./copy.sh
    break
    ;;
  [nN])
    echo "No config files copied"
    break
    ;;
  *)
    echo "Please enter either 'y' or 'n'."
    ;;
  esac
done

# Copy configs
while true; do
  echo "All done!"
  read -rp "Would you like to restart your system (recommended if you installed from scratch)? [y/n]" confirm
  case $confirm in
  [yY])
    sudo reboot
    ;;
  [nN])
    echo "Done!"
    break
    ;;
  *)
    echo "Please enter either 'y' or 'n'."
    ;;
  esac
done
