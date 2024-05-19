#!/bin/bash
## Action menu ##

# Fuzzel prompt for performing various tasks

# Set your menu command here
MENU="fuzzel"
# Set the prompt
PROMPT="Action menu: "
# Scripts directory
SCRIPTSDIR="$HOME/.config/hypr/scripts"
# Set menu arguments
MENUARGS=(-d --width 45 --lines 18 -p "$PROMPT")
# Set menu options
OPTS=("Wallpaper" "Settings" "Keybinds" "Lockscreen" "Refresh" "Logout")
# Set icons for each menu item
ICONS=("wallpaper" "regedit" "keyboard" "lock-screen" "reload" "login")

for ((i=0; i<${#OPTS[@]}; i++)); do
  option="${OPTS[i]}\0icon\x1f${ICONS[i]}\n"
  combined_string+="$option"
done

# Menu prompt
selection=$(echo -en "$combined_string" | $MENU "${MENUARGS[@]}")

# Handle selection
case $selection in
"${OPTS[0]}")
  "$SCRIPTSDIR"/Wallpaper.sh
  ;;
"${OPTS[1]}")
  kitty -e yazi "$HOME/.config/hypr"
  ;;
"${OPTS[2]}")
  fuzzel -d --width=50 --lines=20< "$HOME"/.cache/dots/keybinds.txt
  ;;
"${OPTS[3]}")
  hyprlock
  ;;
"${OPTS[4]}")
  "$SCRIPTSDIR"/Refresh.sh
  ;;
"${OPTS[5]}")
  hyprctl dispatch exit 0
  ;;
*) ;;
esac
