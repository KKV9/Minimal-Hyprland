#!/bin/sh
## Refresh 🔃##

# Reload apps and theme configuration
# Does not reload hyprland
# Use 'hyprctl reload' to reload hyprland settings

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
  touch "$HOME"/.config/qutebrowser/overrides.py
  if pgrep -x "qutebrowser" >/dev/null; then
    qutebrowser :config-source
  fi
}

reload_f() {
  touch "$HOME"/.config/"$1"/overrides.ini
  cat "$HOME"/.config/"$1"/defaults.ini \
    "$HOME"/.config/"$1"/overrides.ini \
    "$HOME"/.cache/wal/"$1".base.ini \
    "$HOME"/.config/"$1"/overrides_colors.ini >"$HOME"/.config/"$1"/"$1".ini
}

reload_mako() {
  # Source colors from wall cache
  . "$HOME"/.cache/wal/colors.sh

  # Mako config file
  mako_config="$HOME/.config/mako"
  conf_file="$mako_config/mako.ini"
  touch "$mako_config/overrides.ini"
  touch "$mako_config/overrides_urgency.ini"

  # Declare options and their new values
  bg_color="background-color"
  bg_color_value="${background}89"
  text_color="text-color"
  text_color_value="$foreground"
  border_color="border-color"
  border_color_value="$color3"
  progress_color="progress-color"
  progress_color_value="source ${color2}89"

  # Replace each option with it's new value
  sed -i "0,/^$bg_color.*/{s//$bg_color=$bg_color_value/}" "$conf_file"
  sed -i "0,/^$text_color.*/{s//$text_color=$text_color_value/}" "$conf_file"
  sed -i "0,/^$border_color.*/{s//$border_color=$border_color_value/}" "$conf_file"
  sed -i "0,/^$progress_color.*/{s//$progress_color=$progress_color_value/}" "$conf_file"

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
  yazi_config="$HOME/.config/yazi/flavors/dots.yazi/flavor.toml"

  # Read the old colors from the config file
  old_color4=$(sed -n '1p' "$yazi_config")
  old_color3=$(sed -n '2p' "$yazi_config")
  old_color8=$(sed -n '3p' "$yazi_config")

  # Replace old colors with new ones
  sed -i "s/$old_color4/$color4/g" "$yazi_config"
  sed -i "s/$old_color3/$color3/g" "$yazi_config"
  sed -i "s/$old_color8/$color8/g" "$yazi_config"
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
reload_f "foot"
reload_f "fuzzel"
reload_yazi
hyprcolors.sh
pkill waybar
sleep 0.3
waybar &

notify-send -u "low" -i emblem-checked "Finished!"
