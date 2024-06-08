#!/bin/fish
# fzf previews 🌸#

# Set image & text previews for fzf

set cmd (EXTERNAL_COLUMNS=$COLUMNS \
fzf --preview='
kitten icat --clear --transfer-mode=memory --place="$COLUMNS"x"$LINES"@(math $EXTERNAL_COLUMNS-$COLUMNS)x0 --align center --stdin=no {} > /dev/tty
if ! file --mime-type {} | grep -qF image/
clear && bat --color always --style numbers --line-range :200 {}
end' --preview-window "right,50%,border-left")

if test -n "$argv"
  echo "$cmd" > $argv
else
  echo "$cmd"
end
