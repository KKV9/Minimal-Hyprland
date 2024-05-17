#!/bin/bash
## Keyboard layouts ##

# File path
file_path="user_configs/Overrides.conf"
DEFAULT_LAYOUT="us"

# Check if the file exists
if [ ! -f "$file_path" ]; then
  echo "File not found: $file_path"
  echo "Please download the full repo to this folder!"
  exit 1
fi

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

while true; do
  # Set layout with fzf
  manual_layout() {
    while true; do
      echo "Select a layout from the following screen"
      read -rp "Press Enter to continue..."
      new_layout=$(localectl list-x11-keymap-layouts | fzf)

      if ! [ "$new_layout" ]; then
        new_layout=$DEFAULT_LAYOUT
      fi

      echo "You selected $new_layout"
      read -rp "Is this correct? [y/n] " confirm
      case "$confirm" in
      [yY])
        break
        ;;
      [nN])
        echo "Try again..."
        ;;
      *)
        echo "Please enter either 'y' or 'n'."
        ;;
      esac
    done
  }

  # Set variant with fzf
  manual_variant() {
    while true; do
      echo "Select a layout from the following screen"
      read -rp "Press Enter to continue..."
      new_variant=$(localectl list-x11-keymap-variants "$new_layout" | fzf)

      if ! [ "$new_variant" ]; then
        echo "You selected default"
      else
        echo "You selected $new_variant"
      fi

      read -rp "Is this correct? [y/n] " confirm
      case "$confirm" in
      [yY])
        break
        ;;
      [nN])
        echo "Try again..."
        ;;
      *)
        echo "Please enter either 'y' or 'n'."
        ;;
      esac
    done
  }

  # Set options with fzf
  manual_caps() {
    while true; do
      read -rp "Swap caps and escape? [y/n] " confirm
      case "$confirm" in
      [yY])
        new_options="caps:swapescape"
        break
        ;;
      [nN])
        new_options="caps:escape"
        break
        ;;
      *)
        echo "Please enter either 'y' or 'n'."
        ;;
      esac
    done
  }

  # Replace keyboard options in Devices.conf
  set_opts() {
    opt=$1
    name=$2
    default=$3

    echo
    if [ "$opt" ]; then
      echo "You selected $name: $opt"
      sed -i "s/\(kb_$name = \).*/\1$opt/" "$file_path"
      sed -i "s/\(kb_$name = \).*/\1$opt/" "sddm/hyprland.conf" # Change layout for sddm
      echo "Keyboard $name changed to $opt"
    else
      echo "You selected $name: default"
      sed -i "s/\(kb_$name = \).*/\1$default/" "$file_path"
      echo "Keyboard $name changed to default $default"
    fi
  }

  # Detect the current keyboard layout
  layout=$(detect_layout)

  # Prompt the user to confirm whether the detected layout is correct
  while true; do
    read -rp "Detected current keyboard layout as: $layout. Is this correct? [y/n] " confirm
    case $confirm in
    [yY])
      # Confirm selected layout, continue with the script
      new_layout=$layout
      break
      ;;
    [nN])
      # Manually set layout, continue with the script
      manual_layout
      break
      ;;
    *)
      echo "Please enter either 'y' or 'n'."
      ;;
    esac
    break
  done

  # Prompt for variant
  while true; do
    echo
    echo "Setting a variant is not necessary in most cases"
    read -rp "Would you like to select a keyboard variant? [y/n] " confirm
    case $confirm in
    [yY])
      # Confirm selected layout, continue with the script
      manual_variant
      break
      ;;
    [nN])
      # Continue with the script
      new_variant=""
      break
      ;;
    *)
      echo "Please enter either 'y' or 'n'."
      ;;
    esac
    break
  done

  # Prompt for options
  while true; do
    echo
    read -rp "Would you map capslock to escape? [y/n] " confirm
    case $confirm in
    [yY])
      # Change caps lock key, continue with the script
      manual_caps
      break
      ;;
    [nN])
      # Continue with the script
      new_options=""
      break
      ;;
    *)
      echo "Please enter either 'y' or 'n'."
      ;;
    esac
    break
  done

  # Print reciept
  echo
  echo "######################################"
  # Set each of the options
  set_opts "$new_layout" "layout" $DEFAULT_LAYOUT
  set_opts "$new_variant" "variant"
  set_opts "$new_options" "options"
  echo
  echo "######################################"
  echo

  # Prompt to restart the script
  while true; do
    read -rp "Proceed? [y/n] " confirm
    case $confirm in
    [yY])
      proceed="yes"
      break
      ;;
    [nN])
      # Restart
      proceed="no"
      break
      ;;
    *)
      echo "Please enter either 'y' or 'n'."
      ;;
    esac
  done

  if [ "$proceed" == "yes" ]; then
    break
  fi

done
