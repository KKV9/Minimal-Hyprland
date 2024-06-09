#!/bin/sh
## Keyboard layouts ##

while true; do
  # Check if the directory is correct
  if [ ! -f install.sh ]; then
    cd ..
    if [ ! -f install.sh ]; then
      echo "File not found: install.sh"
      echo "Please download the full repo!"
      exit 1
    fi
  fi

  . install_scripts/functions.sh

  # Check if the file exists
  if [ ! -f "$OVERRIDES" ]; then
    echo "File not found: $OVERRIDES"
    exit 1
  fi

  # Detect the current keyboard layout
  layout=$(detect_layout)

  if ask_yn "Detected current keyboard layout as: $layout. Is this correct?"; then
    new_layout=$layout
  else
    new_layout=$(manual_keys "list-x11-keymap-layouts" "$DEFAULT_LAYOUT")
  fi

  if ask_yn "Set a keyboard variant?"; then
    new_variant=$(manual_keys "list-x11-keymap-variants" "" "$new_layout")
  fi

  if ask_yn "Map capslock to escape?"; then
    if ask_yn "Swap caps and escape?"; then
      new_options="caps:swapescape"
    else
      new_options="caps:escape"
    fi
  fi

  # Print reciept
  echo
  echo "######################################"
  # Set each of the options
  set_opts "$new_layout" "layout" "$DEFAULT_LAYOUT"
  set_opts "$new_variant" "variant"
  set_opts "$new_options" "options"
  echo
  echo "######################################"
  echo

  if ask_yn "Confirm options?"; then
    break
  fi
done
