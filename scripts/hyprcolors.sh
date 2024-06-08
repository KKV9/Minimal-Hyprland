#!/bin/bash
## Hyprland colors 🎨##
# Set hyprland colors

# Import colors from cache
. "$HOME/.cache/wal/colors.sh"

# Set with hyprctl
hyprctl keyword '$foregroundCol' "0xff${foreground:1}"
hyprctl keyword '$backgroundCol' "0xff${background:1}"

for i in {0..15}; do
  # Combine "color@" variable
  var="color$i"
  value="${!var}"
  # Set
  hyprctl keyword "\$color$i" "0xff${value:1}" -r
done
