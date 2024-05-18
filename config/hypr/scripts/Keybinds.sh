#!/bin/bash
## Keybinds generator ##

CACHE="$HOME/.cache/dots"
CONFIGS="$HOME"/.config/hypr

# Replace cache folder
rm -rf "$CACHE"
mkdir -p "$CACHE"


# Input and file
json_file="$CACHE/keybinds.json"
output="$HOME/.cache/dots/keybinds.txt"

# Concatenate user configs with base keybindings
tmp=$(mktemp)
cat "$CONFIGS"/user_configs/*.conf "$CONFIGS"/KeyBinds.conf >"$tmp"

# Generate json file
hyprkeys -bjl -c "$tmp" >"$json_file"

# Remove temp catted file
rm "$tmp"

## Parse json file
# Substitute number codes for their corresponding number
# Substitute mouse codes for LMB/RMB
# Reduce workspace 1-9 to one entry each
# Only output unique bind and comments
jq -r '
  .Binds |= (
    map(
      .Bind |= sub("code:10"; "1") |
      .Bind |= sub("code:11"; "2") |
      .Bind |= sub("code:12"; "3") |
      .Bind |= sub("code:13"; "4") |
      .Bind |= sub("code:14"; "5") |
      .Bind |= sub("code:15"; "6") |
      .Bind |= sub("code:16"; "7") |
      .Bind |= sub("code:17"; "8") |
      .Bind |= sub("code:18"; "9") |
      .Bind |= sub("code:19"; "0") |
      .Bind |= sub("mouse:272"; "mouse_LMB") |
      .Bind |= sub("mouse:273"; "mouse_RMB") |
      .Comments |= sub("workspace [1-9]$"; "workspace [1-9]") |
      if (.Comments | test("workspace \\[1-9\\]$")) then
        .Bind |= sub("[0-9]$"; "[1-9]")
      else
        .
      end
    ) | unique_by(.Bind, .Comments)
  ) | .Binds[] | "\(.Comments), \(.Bind)"
' "$json_file" | awk -F, -v max_length="30" '{ 
    printf "%-" max_length "s %s\n", $1, $2 
}' >"$output"
