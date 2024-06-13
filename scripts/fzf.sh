#!/bin/sh
# fzf previews 🌸#

# Image/text file picker with fzf

cmd=$(fzf --preview='
    img2sixel -q low -w 660 {}
    if ! file --mime-type {} | grep -qF image/
    clear && bat --color always --style numbers --line-range :200 {}
    end' --preview-window "right,50%,border-left")

if [ -z "$1" ]; then
	echo "$cmd"
else
	echo "$cmd" >"$1"
fi
