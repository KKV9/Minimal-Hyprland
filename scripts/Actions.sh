#!/bin/bash
## Action menu ❗##

# Fuzzel prompt for performing various tasks

# Set fuzzel args
menuargs=(-d --width 45 --lines 18 -p "$prompt")

# Check the first argument
case "$1" in
"--power")
  prompt="⚡: "
  opts=("Lock" "Logout"
    "Suspend" "Reboot"
    "Reboot to UEFI" "Shutdown")
  icons=("system-lock-screen" "system-log-out"
    "system-suspend-hibernate" "system-reboot"
    "computer" "system-shutdown")
  ;;
"--projector")
  # Check for external monitor
  if hyprctl monitors all |
    grep -e "HDMI-A-1" &&
    hyprctl monitors all |
    grep -e "eDP-1"; then
    prompt="🖥 : "
    opts=("Main Screen Only" "Duplicate"
      "Extend" "Second Screen Only")
    icons=("computer-laptop" "computer"
      "video-display" "video-television")
  else
    # Exit when no external display found
    notify-send -u low -i "computer" "Projector menu" \
      "No external monitor found"
    exit 0
  fi
  ;;
*)
  prompt="❗: "
  opts=("Settings" "Wallpaper"
    "Keybinds" "Refresh"
    "Power Menu")
  icons=("regedit" "wallpaper"
    "keyboard" "reload"
    "system-switch-user")
  ;;
esac

# Combine each opt with it's icon separated by a newline
for ((i = 0; i < ${#opts[@]}; i++)); do
  option="${opts[i]}\0icon\x1f${icons[i]}\n"
  combined_string+="$option"
done

# Menu prompt
selection=$(echo -en "$combined_string" | $MENU "${menuargs[@]}")

case "$1" in
"--power")
  # Handle options for power menu
  case "$selection" in
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
  esac
  ;;
"--projector")
  # Handle options for projector menu
  if [ -n "$selection" ]; then
    # Get hyprland defaults if an option is selected and reload colors
    hyprctl reload && Hyprcolors.sh
  fi
  case "$selection" in
  "${opts[0]}")
    hyprctl keyword monitor HDMI-A-1,disable
    ;;
  "${opts[1]}")
    hyprctl keyword monitor HDMI-A-1,highrr,0x0,auto,mirror,eDP-1
    ;;
  "${opts[3]}")
    hyprctl keyword monitor eDP-1,disable
    ;;
  esac
  if [ -n "$selection" ]; then
    # Reload waybar if an option is selected
    # Waybar can have problems after changing monitor settings
    killall waybar
    waybar &
  fi
  ;;
*)
  # Handle options for actions menu
  case "$selection" in
  "${opts[0]}")
    kitty -e yazi "$HOME/.config/hypr/user_configs"
    ;;
  "${opts[1]}")
    Wallpaper.sh
    ;;
  "${opts[2]}")
    fuzzel -d --width=50 --lines=20 <"$HOME"/.cache/dots/keybinds.txt
    ;;
  "${opts[3]}")
    Refresh.sh
    ;;
  "${opts[4]}")
    Actions.sh "--power"
    ;;
  esac
  ;;
esac
