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
MENUARGS=(-d -l 6 -p "$PROMPT")
# Set menu options
OPTS=("1. Select a wallpaper" "2. Edit configs" "3. Show keybinds" "4. Lock" "5. Refresh" "6. Exit")
# Menu prompt
selection=$(printf '%s\n' "${OPTS[@]}" | $MENU "${MENUARGS[@]}")

# Handle selection
case $selection in
"${OPTS[0]}")
  "$SCRIPTSDIR"/Wallpaper.sh
  ;;
"${OPTS[1]}")
  kitty -e yazi "$HOME/.config/hypr"
  ;;
"${OPTS[2]}")
  fuzzel -d --width=50< "$HOME"/.cache/dots/keybinds.txt
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
