#!/bin/sh
## Clipboard 📋##

# Retrieve clipboard history

# Allow clearing clipboard history
sel=$(printf "%s\n%s" "clear" "$(cliphist list)" |
  fuzzel -d -w 100 -p "📋: ")

if [ "$sel" = "clear" ]; then
  # Wipe when clear is selected
  wl-copy --clear
  cliphist wipe
else
  # Decode selected to raw text
  dec=$(echo "$sel" | cliphist decode)
  if [ -n "$dec" ]; then
    # Copy and notify if text is selected
    wl-copy "$dec"
    notify-send -u low -i "clipboard" "Clipboard" "Copied: $dec"
  fi
fi
