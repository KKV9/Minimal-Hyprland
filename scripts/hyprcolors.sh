#!/bin/bash
# shellcheck disable=all
## Hyprland colors 🎨##
# Set hyprland colors

# Import colors from cache
. "$HOME/.cache/wal/colors.sh"

# Set with hyprctl
hyprctl keyword '$foregroundCol' "0xff${foreground:1}" -r
hyprctl keyword '$backgroundCol' "0xff${background:1}" -r
hyprctl keyword '$color0' "0xff${color0:1}" -r
hyprctl keyword '$color1' "0xff${color1:1}" -r
hyprctl keyword '$color2' "0xff${color2:1}" -r
hyprctl keyword '$color3' "0xff${color3:1}" -r
hyprctl keyword '$color4' "0xff${color4:1}" -r
hyprctl keyword '$color5' "0xff${color5:1}" -r
hyprctl keyword '$color6' "0xff${color6:1}" -r
hyprctl keyword '$color7' "0xff${color7:1}" -r
hyprctl keyword '$color8' "0xff${color8:1}" -r
hyprctl keyword '$color9' "0xff${color9:1}" -r
hyprctl keyword '$color10' "0xff${color10:1}" -r
hyprctl keyword '$color11' "0xff${color11:1}" -r
hyprctl keyword '$color12' "0xff${color12:1}" -r
hyprctl keyword '$color13' "0xff${color13:1}" -r
hyprctl keyword '$color14' "0xff${color14:1}" -r
hyprctl keyword '$color15' "0xff${color15:1}" -r
