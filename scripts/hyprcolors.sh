#!/bin/bash
## Hyprland colors 🎨##

# Set hyprland border color

# Import colors from cache
. "$HOME/.cache/wal/colors.sh"

# Set with hyprctl
hyprctl keyword '$BORDER_COLOR' "0xff${color3:1}" -r
