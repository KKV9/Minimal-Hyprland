#!/bin/bash
## Action menu ##

# Dmenu prompt for performing various tasks

# Set your menu command here
MENU="fuzzel"
# Set the prompt
PROMPT="Action menu: "
# Scripts directory
SCRIPTSDIR="$HOME/.config/hypr/scripts"

# Set menu arguments
case $MENU in
"rofi")
  menuArgs=(-dmenu -l 6 -p "$PROMPT")
  ;;
"fuzzel" | "wofi")
  menuArgs=(-d -l 6 -p "$PROMPT")
  ;;
"tofi")
  menuArgs=(--prompt-text "$PROMPT")
  ;;
"dmenu")
  menuArgs=(-p "$PROMPT")
  ;;
*)
  menuArgs=()
  ;;
esac

# Set menu options
opts=("1. Select a wallpaper" "2. Edit configs" "3. Show keybinds" "4. Lock" "5. Refresh" "6. Exit")

# Menu prompt
selection=$(printf '%s\n' "${opts[@]}" | $MENU "${menuArgs[@]}")

# Handle selection
case $selection in
"${opts[0]}")
  "$SCRIPTSDIR"/Wallpaper.sh
  ;;
"${opts[1]}")
  kitty -e yazi "$HOME/.config/hypr"
  ;;
"${opts[2]}")
  fuzzel -d --width=50< "$HOME"/.cache/dots/keybinds.txt
  ;;
"${opts[3]}")
  hyprlock
  ;;
"${opts[4]}")
  "$SCRIPTSDIR"/Refresh.sh
  ;;
"${opts[5]}")
  hyprctl dispatch exit 0
  ;;
*) ;;
esac
