#!/bin/bash
## Sddm ##

# Download theme
echo "Downloading sddm themes..."
wget "https://github.com/catppuccin/sddm/releases/download/v1.0.0/catppuccin-mocha.zip"

# Unarchive
echo "Extracting sddm themes..."
unzip catppuccin-mocha.zip

# Change font
sed -i 's/Noto Sans/JetBrainsMono NF/g' catppuccin-mocha/theme.conf

# Copy themes
echo "Copying sddm themes..."
sudo mkdir -p "/usr/share/sddm/themes"
sudo mv "catppuccin-mocha/" "/usr/share/sddm/themes/"

## Copy configs
sudo mkdir -p /etc/sddm.conf.d
sudo cp -rf sddm/* "/etc/sddm.conf.d/"

# clean up
rm "catppuccin-mocha.zip"
rm -r "catppuccin-mocha/"
