#!/bin/bash
## Action menu ❗##

# Fuzzel prompt for performing various tasks

# Set your menu command here
MENU="fuzzel"
# Scripts directory
SCRIPTSDIR="$HOME/.config/hypr/scripts"

# Override variables for power menu
if [ "$1" == "--power" ]; then
  # Set the prompt
  prompt="⚡: "
  # Set menu options
  opts=("Lock" "Logout"
    "Suspend" "Reboot"
    "Reboot to UEFI" "Shutdown")
  # Set icons for each menu item
  icons=("system-lock-screen" "system-log-out"
    "system-suspend-hibernate" "system-reboot"
    "computer" "system-shutdown")
else
  # Set the prompt
  prompt="❗: "
  # Set menu options
  opts=("Settings" "Wallpaper"
    "Keybinds" "Refresh"
    "Power Menu")
  # Set icons for each menu item
  icons=("regedit" "wallpaper"
    "keyboard" "reload"
    "system-switch-user")
fi

# Set menu arguments
menuargs=(-d --width 45 --lines 18 -p "$prompt")

# Combine each opt with it's icon separated by a newline
for ((i = 0; i < ${#opts[@]}; i++)); do
  option="${opts[i]}\0icon\x1f${icons[i]}\n"
  combined_string+="$option"
done

# Menu prompt
selection=$(echo -en "$combined_string" | $MENU "${menuargs[@]}")

if [ "$1" == "--power" ]; then
  # Handle options for power
  case $selection in
  "${opts[0]}")
    hyprlock
    ;;
  "${opts[1]}")
    hyprctl dispatch exit 0
    ;;
  "${opts[2]}")
    systemctl suspend
    ;;
  "${opts[3]}")
    systemctl reboot
    ;;
  "${opts[4]}")
    systemctl reboot --firmware-setup
    ;;
  "${opts[5]}")
    systemctl poweroff
    ;;
  *) ;;
  esac
else
  # Handle options for actions
  case $selection in
  "${opts[0]}")
    kitty -e yazi "$HOME/.config/hypr/user_configs"
    ;;
  "${opts[1]}")
    "$SCRIPTSDIR"/Wallpaper.sh
    ;;
  "${opts[2]}")
    fuzzel -d --width=50 --lines=20 <"$HOME"/.cache/dots/keybinds.txt
    ;;
  "${opts[3]}")
    "$SCRIPTSDIR"/Refresh.sh
    ;;
  "${opts[4]}")
    "$SCRIPTSDIR"/Actions.sh "--power"
    ;;
  *) ;;
  esac
fi
