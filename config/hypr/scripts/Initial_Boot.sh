#!/bin/bash
## Initial boot ##

# Make sure config files install smoothly by
# refreshing configuration on first boot.

if test -f "$HOME/.config/INITIAL_BOOT"; then
  sleep 0.5
  "$HOME"/.config/hypr/scripts/Refresh.sh
  rm "$HOME"/.config/INITIAL_BOOT
fi
