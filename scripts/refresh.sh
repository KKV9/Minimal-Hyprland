#!/bin/bash
## Refresh 🔃##

# Reload full hyprland configuration

reload_gtk_theme() {
  # find current theme
  theme=$(gsettings get org.gnome.desktop.interface gtk-theme)

  # Apply blank theme
  gsettings set org.gnome.desktop.interface gtk-theme ''
  sleep 0.3

  # Apply current theme again
  gsettings set org.gnome.desktop.interface gtk-theme "$theme"
}

reload_qutebrowser() {
  if pgrep -x "qutebrowser" >/dev/null; then
    qutebrowser :config-source
  fi
}

reload_kitty() {
  # Get process IDs of all running kitty instances
  pids=$(pgrep -x kitty)

  if [ -n "$pids" ]; then
    # Send SIGUSR1 signal to reload config of each kitty instance
    for pid in $pids; do
      kill -SIGUSR1 "$pid"
    done
  fi
}

reload_mako() {
  # Source colors from wall cache
  . "$HOME"/.cache/wal/colors.sh

  # Mako config file
  conffile="$HOME/.config/mako/config"

  # Associative array, color name -> color code.
  declare -A colors
  colors=(
    ["background-color"]="${background}89"
    ["text-color"]="$foreground"
    ["border-color"]="$color3"
    ["progress-color"]="source ${color2}89"
  )

  for color_name in "${!colors[@]}"; do
    # replace first occurance of each color in config file
    sed -i "0,/^$color_name.*/{s//$color_name=${colors[$color_name]}/}" "$conffile"
  done

  makoctl reload
}

# Notify user
notify-send -u "low" -i emblem-synchronizing "Reloading desktop theme..."

# Remove color scheme cache
rm -r "$HOME/.cache/wal/schemes"

# Refresh colors, waybar, gtk & other apps
# Qt apps are not reloaded by this process
wal -i "$HOME/.cache/current_wallpaper.png" -s -t -n -e >/dev/null
Keybinds.sh # Generate keybinds
reload_gtk_theme
reload_qutebrowser
reload_kitty
reload_mako
hyprcolors.sh
pkill waybar
sleep 0.3
waybar &

notify-send -u "low" -i emblem-checked "Finished!"
