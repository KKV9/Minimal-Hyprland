#!/bin/sh
## Hyprland colors 🎨##
# shellcheck disable=all
# Set hyprland colors

# Import colors from cache
. "$HOME/.cache/wal/colors.sh"

# Set with hyprctl
hyprctl keyword '$foregroundCol' "0xff${foreground#?}"
hyprctl keyword '$backgroundCol' "0xff${background#?}"
hyprctl keyword '$color0' "0xff${color0#?}"
hyprctl keyword '$color1' "0xff${color1#?}"
hyprctl keyword '$color2' "0xff${color2#?}"
hyprctl keyword '$color3' "0xff${color3#?}"
hyprctl keyword '$color4' "0xff${color4#?}"
hyprctl keyword '$color5' "0xff${color5#?}"
hyprctl keyword '$color6' "0xff${color6#?}"
hyprctl keyword '$color7' "0xff${color7#?}"
hyprctl keyword '$color8' "0xff${color8#?}"
hyprctl keyword '$color9' "0xff${color9#?}"
hyprctl keyword '$color10' "0xff${color10#?}"
hyprctl keyword '$color11' "0xff${color11#?}"
hyprctl keyword '$color12' "0xff${color12#?}"
hyprctl keyword '$color13' "0xff${color13#?}"
hyprctl keyword '$color14' "0xff${color14#?}"
hyprctl keyword '$color15' "0xff${color15#?}" -r
