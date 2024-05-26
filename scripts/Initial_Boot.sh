#!/bin/bash
## Initial boot 💥##

# Make sure config files install smoothly by
# refreshing configuration on first boot
# and touchpad detection if using a laptop.

CONFIGSUSR="$HOME/.config/hypr/user_configs"
DEVICECONFIGUSR="$CONFIGSUSR/Touchpad.conf"
OVERRIDESUSR="$CONFIGSUSR/Overrides.conf"
SOURCESTRING="source = Touchpad.conf"

detect_devices() {
  device=$(hyprctl devices | grep -e "-touchpad" | xargs)

  if [ -z "$device" ]; then
    exit 0
  fi

  device_config='# Touchpad device detected
$TOUCHPAD_ENABLED = true
device {
      name = '
  device_config+="$device"
  device_config+='
      enabled = $TOUCHPAD_ENABLED
      sensitivity = 0.0
}'

  if ! test -f "$DEVICECONFIGUSR"; then
    echo "$device_config" >"$DEVICECONFIGUSR"

    if ! grep -e \
      "$SOURCESTRING" "$OVERRIDESUSR" \
      >/dev/null; then

      printf \
        "\n\n## Devices detected by Initial_Boot.sh ##\n" \
        >>"$OVERRIDESUSR"

      echo "$SOURCESTRING" >>"$OVERRIDESUSR"
    fi
  fi
}

if test -f "$HOME/.config/INITIAL_BOOT"; then
  chown "$USER" "$HOME/.config/user-dirs.dirs"
  xdg-user-dirs-update --force

  gsettings set \
    org.gnome.desktop.interface cursor-theme \
    'Bibata-Modern-Classic'

  gsettings set \
    org.gnome.desktop.interface font-name \
    'JetBrainsMono Nerd Font'

  gsettings set \
    org.gnome.desktop.interface icon-theme \
    'Tela-dark'

  detect_devices
  sleep 0.5
  "$HOME"/.config/hypr/scripts/Refresh.sh

  if hyprctl monitors | grep "1920x1200@"; then
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
    echo "env = QT_SCALE_FACTOR,1.25" >>"$OVERRIDESUSR"
    notify-send -u critical -i "monitor" "Initial Boot" "Hidpi monitor detected. Please log out and log back in to see scaling changes!"
  fi

  rm "$HOME"/.config/INITIAL_BOOT
fi
