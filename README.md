# Minimal Hyprland
Beautiful, minimal config for hyprland. Using pywal for theming gtk, qt and various other apps.
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

## What next?
- Press `SUPER + A` to bring up a list of actions.
- Editing the config files should be your priority.
- The monitor must be setup manually for now.
- You will have to run some commands after starting NvChad. `Lazy sync` and `MasonInstallAll`
- Run the following after starting Qutebrowser. `adblock-update`
- Then download some wallpapers and enjoy the beautiful theming.

## Contributing
I'm happy to recieve any PRs or issues you might have.
There is alot of refinement and features to be added still.
