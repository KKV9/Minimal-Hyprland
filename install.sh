#!/bin/bash
## Install dots ##

chmod +x install_scripts/*.sh
source install_scripts/functions.sh

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
  echo "This script should not be executed as root! Exiting......."
  exit 1
fi

# Greet
echo "Welcome to the installer"
echo "ATTENTION: Please backup your configuration files before proceeding!"

# Give option to cancel install
if ! ask_yn "Do you want to proceed?"; then
  exit 0
fi

# Option to automatically install dependencies
# Sddm install is optional
if ask_yn "Install dependencies?"; then
  if ask_yn "Install sddm?"; then
    ./install_scripts/dependencies.sh "sddm"
  else
    ./install_scripts/dependencies.sh
  fi
else
  echo "No dependencies installed"
fi

# Ask to change keyboard layout if not done already
if [ ! -f "$USERCONFIG" ]; then
  if ask_yn "Would you like to change the default keyboard layout (us)?"; then
    ./install_scripts/keyboard_layout.sh
  else
    echo "Keyboard layout remains unchanged"
  fi
fi

# Prompt to copy config files
if ask_yn "Would you like to copy the config files?"; then
  ./install_scripts/copy.sh
else
  echo "No config files copied"
fi

# Notify install complete
echo "Install complete!"
echo "Restart your system if installing for the first time!"
