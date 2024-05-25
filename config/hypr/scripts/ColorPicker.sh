#!/bin/bash
## Color picker 🌈##

# Hyprpicker wrapper

MAKOCONFIG=$HOME/.config/mako/config
result=$(hyprpicker -an)
tmp=$(mktemp)

# Swap second occurance of border-color
awk '/border-color=/ && ++count == 2 {sub(/border-color=.*/, "border-color='"$result"'")} 1' \
  "$MAKOCONFIG" >"$tmp" \
  && mv "$tmp" "$MAKOCONFIG"
makoctl reload
notify-send -u "normal" "$result Copied to clipboard"
