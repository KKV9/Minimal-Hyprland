#!/bin/sh

CACHE="$HOME/.cache/dots"
OUTPUT_TEXT="$CACHE/keybinds.txt"

# Dispatch tells where to start cutting
dispatchers="exe pas sen kil clo mov wor tog set fak ful dpm pin res cen cyc swa tag foc spl ren exi for bri alt cha loc den set glo sub"

# Create temporary output files
temp_binds=$(mktemp)
temp_strip=$(mktemp)

mkdir -p "$CACHE"

# Extract lines starting with 'bind' or 'unbind' and save to temp_binds
cat "$HOME/.config/hypr/hyprbinds.conf" "$HOME"/.config/hypr/user_configs/* | grep -E "^bind|^unbind"  >"$temp_binds"

# Create temporary files for each field (mod, key, comment)
temp_mod=$(mktemp)
temp_key=$(mktemp)
temp_comment=$(mktemp)

# Preserve comments before stripping
awk -F "#" '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}' "$temp_binds" >"$temp_comment"

# Strip dispatchers onwards from each line
for d in $dispatchers; do
  sed -ie "s/${d}.*//" "$temp_binds"
done

# Extract and clean up each part of the bind/unbind lines
sed -i -e "s/^bind.*=\s*/bind\t/" -e "s/^unbind.*=\s*/unbind\t/" "$temp_binds"
awk -F "," '{print $1}' "$temp_binds" >"$temp_mod"
awk -F "," '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}' "$temp_binds" >"$temp_key"

# Combine all parts into a single file
paste "$temp_mod" "$temp_key" "$temp_comment" >"$temp_strip"

# Find unbind commands and remove corresponding bind commands
grep -e "^unbind" "$temp_strip" | awk '{print $2 "\t" $3}' |
  while IFS= read -r line && [ -n "$line" ]; do
    sed -i "0,/^bind\t$line\t.*/{//d;}" "$temp_strip"
  done

# Output the result, excluding all unbind lines and first column
grep -ve "^unbind" "$temp_strip" | cut -c6- | column -t -s "$(printf "\t")" >"$OUTPUT_TEXT"

# Clean up temporary files
rm "$temp_binds" "$temp_mod" "$temp_key" "$temp_comment" "$temp_strip"
