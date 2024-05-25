#!/bin/bash
## Emoji selector 😀##

# Fuzzel prompt for selecting emoji

DATADIR="$HOME/.config/hypr/data"

result=$(fuzzel -d --width=60 <"$DATADIR"/Emoji | awk '{print $1}')

if [ -n "$result" ]; then
  echo -n "$result" | wl-copy
  notify-send -u low "$result Copied to clipboard!"
fi
