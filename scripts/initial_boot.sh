#!/bin/sh
## Initial boot 💥##

# Make sure config files install smoothly by
# refreshing configuration on first boot
# and touchpad detection if using a laptop.

# Set constants
CONFIGS_USR="$HOME/.config/hypr/user_configs"
DEVICE_CONFIG_USR="$CONFIGS_USR/touchpad.conf"
OVERRIDES_USR="$CONFIGS_USR/overrides.conf"
SOURCE_STRING="source = touchpad.conf"

detect_devices() {
  # Look for touchpad
  device=$(hyprctl devices | grep -e "-touchpad" | xargs)

  if [ -z "$device" ]; then
    # Exit function on no touchpad
    return 0
  fi

  # Create device config string for user configuration
  # Only $device variable gets expanded.
  # $TOUCHPAD_ENABLED variable allows for
  # disabling the touchpad with reloading hyprland
  device_config="# Touchpad device detected
\$TOUCHPAD_ENABLED = true # This variable is toggled by touchpad.sh
device {
  name = $device
  enabled = \$TOUCHPAD_ENABLED
  sensitivity = 0.0
}"

  if ! test -f "$DEVICE_CONFIG_USR"; then
    # Write device string into user config file
    echo "$device_config" >"$DEVICE_CONFIG_USR"

    if ! grep -e \
      "$SOURCE_STRING" "$OVERRIDES_USR" \
      >/dev/null; then

      # Source touchpad configuration file from user overrides file
      printf \
        "\n\n## Devices detected by initial_boot.sh ##\n\n%s" \
        "$SOURCE_STRING" \
        >>"$OVERRIDES_USR"
    fi
  fi
}

apply_scaling() {
  if hyprctl monitors | grep "1920x1200@"; then
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
    echo "env = QT_SCALE_FACTOR,1.25" >>"$OVERRIDES_USR"
    notify-send -u critical -i "monitor" "Initial Boot" "Hidpi monitor detected. Please log out and log back in to see scaling changes!"
  fi
}

# Look for INITIAL_BOOT file created by the installer
if test -f "$HOME/.config/INITIAL_BOOT"; then
  # Create common folders in the home directory
  chown "$USER" "$HOME/.config/user-dirs.dirs"
  xdg-user-dirs-update --force

  # Set cursor theme
  gsettings set \
    org.gnome.desktop.interface cursor-theme \
    'Bibata-Modern-Classic'
  hyprctl setcursor Bibata-Modern-Classic 24

  # Set font
  gsettings set \
    org.gnome.desktop.interface font-name \
    'JetBrainsMono Nerd Font'

  # Set icon theme
  gsettings set \
    org.gnome.desktop.interface icon-theme \
    'Tela-dark'

  # Run detect devices function
  detect_devices
  sleep 0.5

  # First refresh to generate cache
  refresh.sh

  # Detect monitor and apply scaling
  # Work in progress...
  apply_scaling

  # Remove the file so this script is not run again
  rm "$HOME"/.config/INITIAL_BOOT
fi
