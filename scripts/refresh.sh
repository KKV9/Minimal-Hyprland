#!/bin/bash
## Refresh 🔃##

# Reload full hyprland configuration

reload_gtk_theme() {
  local theme
  # find current theme
  theme=$(gsettings get org.gnome.desktop.interface gtk-theme)

  # Apply blank theme
  gsettings set org.gnome.desktop.interface gtk-theme ''
  sleep 0.3

  # Apply current theme again
  gsettings set org.gnome.desktop.interface gtk-theme "$theme"
}

reload_qutebrowser() {
  touch "$HOME"/.config/qutebrowser/overrides.py
  if pgrep -x "qutebrowser" >/dev/null; then
    qutebrowser :config-source
  fi
}

reload_kitty() {
  local pids
  touch "$HOME"/.config/kitty/overrides.conf
  # Get process IDs of all running kitty instances
  pids=$(pgrep -x kitty)

  if [ -n "$pids" ]; then
    # Send SIGUSR1 signal to reload config of each kitty instance
    for pid in $pids; do
      kill -SIGUSR1 "$pid"
    done
  fi
}

reload_fuzzel() {
  touch "$HOME"/.config/fuzzel/overrides.ini
  cat  "$HOME"/.config/fuzzel/defaults.ini \
    "$HOME"/.config/fuzzel/overrides.ini \
    "$HOME"/.cache/wal/fuzzel.base.ini \
    "$HOME"/.config/fuzzel/overrides_colors.ini >"$HOME"/.config/fuzzel/fuzzel.ini
}

reload_mako() {
  local colors

  # Source colors from wall cache
  . "$HOME"/.cache/wal/colors.sh

  # Mako config file
  local mako_config="$HOME/.config/mako"
  local conf_file="$mako_config/mako.ini"
  touch "$mako_config/overrides.ini"
  touch "$mako_config/overrides_urgency.ini"

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
    sed -i "0,/^$color_name.*/{s//$color_name=${colors[$color_name]}/}" "$conf_file"
  done

  # Generate the config file by concatentation
  cat "$mako_config"/mako.ini \
    "$mako_config"/overrides.ini \
    "$mako_config"/mako_urgency.ini \
    "$mako_config"/overrides_urgency.ini >"$mako_config"/config

  makoctl reload
}

reload_yazi() {
  # Source colors from wall cache
  . "$HOME"/.cache/wal/colors.sh

  # Yazi config file
  local yazi_config="$HOME/.config/yazi/flavors/dots.yazi/flavor.toml"
  
  # Define the new colors to replace
  local new_colors=("$color4" "$color3" "$color8")
  
  # Read the old colors from the config file
  mapfile -t old_colors < <(head -n 3 "$yazi_config")
  
  # Loop through the arrays and replace old colors with new ones
  for i in {0..2}; do
    sed -i "s/${old_colors[i]}/${new_colors[i]}/g" "$yazi_config"
  done
}

# Notify user
notify-send -u "low" -i emblem-synchronizing "Reloading desktop theme..."

# Remove color scheme cache
rm -r "$HOME/.cache/wal/schemes"

# Refresh colors, waybar, gtk & other apps
# Qt apps are not reloaded by this process
wal -i "$HOME/.cache/current_wallpaper.png" -s -t -n -e --saturate 0.5 >/dev/null
keybinds.sh # Generate keybinds
reload_gtk_theme
reload_qutebrowser
reload_kitty
reload_mako
reload_fuzzel
reload_yazi
hyprcolors.sh
pkill waybar
sleep 0.3
waybar &

notify-send -u "low" -i emblem-checked "Finished!"
