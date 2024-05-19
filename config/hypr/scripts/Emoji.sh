#!/bin/bash
## Emoji selector ##

SCRIPTSDIR="$HOME/.config/hypr/scripts"

# Fuzzel prompt for selecting emoji

result=$(fuzzel -d --width=60 <"$SCRIPTSDIR"/Emoji.txt | awk '{print $1}')

if [ -n "$result" ]; then
    echo -n "$result" | wl-copy
    notify-send -u low "$result Copied to clipboard!"
fi
