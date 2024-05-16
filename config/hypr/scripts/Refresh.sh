#!/bin/bash
## Refresh ##

reload_gtk_theme() {
  theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
  gsettings set org.gnome.desktop.interface gtk-theme ''
  sleep 0.3
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
  . "${HOME}"/.cache/wal/colors.sh

  conffile="$HOME/.config/mako/config"

  # Associative array, color name -> color code.
  declare -A colors
  colors=(
    ["background-color"]="${background}89"
    ["text-color"]="$foreground"
    ["border-color"]="$color13"
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
reload_gtk_theme
reload_qutebrowser
reload_kitty
reload_mako
hyprctl reload
pkill waybar
sleep 0.3
waybar &

notify-send -u "low" -i emblem-checked "Finished!"
