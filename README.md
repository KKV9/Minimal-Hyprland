# Minimal Hyprland
Beautiful, minimal config for hyprland with all the modern amenities. 
Theming is handled by pywal.
Fish shell is optional, it is set as the default interactive shell in hyprland, your login shell will be untouched.
The provided scripts will automate the install process from a minimal archlinux install.

## Default apps
- Browser: Qutebrowser
- File manager: Yazi
- Terminal emulator: Kitty
- Text editor: NvChad
- Launcher: Fuzzel
- Bar: Waybar
- Media: mpv

## How to install

### Installation
Clone this repo and run the install.sh script.
Upgrading from a previous version is the same process, the installer will detect a previous install.

```Bash
git clone https://github.com/KKV9/Minimal-Hyprland.git
cd Minimal-Hyprland
chmod +x install.sh
./install.sh
```

## Post install
### Keybinds
- Press `SUPER + A` to bring up a list of actions.
- Select keybinds from the menu for a list of searchable binds.

### Apps
- NvChad: Run `Lazy sync` followed by `MasonInstallAll` to update.
- Qutebrowser: Run `adblock-update` to update the adblocker.

### Themes
- System themes are generated after a wallpaper change.
- Download some wallpapers and try it out.

### Asus ROG laptops
- Go to <a href="https://asus-linux.org/">asus-linux</a> and follow the setup guide.
- Function keys should be mostly functional.

## Contributing
I'm happy to recieve any PRs or issues you might have.
There is alot of refinement and features to be added still.
