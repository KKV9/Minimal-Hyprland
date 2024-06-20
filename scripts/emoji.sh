#!/bin/sh
## Emoji selector 😀##

# Fuzzel prompt for selecting emoji

DATADIR="$HOME/.local/share/dots"

result=$(fuzzel -d --width=60 <"$DATADIR"/emoji | cut -d " " -f 1)

if [ -n "$result" ]; then
	wl-copy "$result"
	notify-send -u low "$result Copied to clipboard!"
fi
