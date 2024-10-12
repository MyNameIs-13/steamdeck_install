# SteamOS install

personal install and configuration script for steamdeck.
It will configure the system with [ansible](https://www.ansible.com/) and the user environment with [chezmoi](https://www.chezmoi.io/).
this repo only handles the installation and system configuration (with ansible).
Dotfiles handling and user envirnment configuration is part of the dotfiles repo which is managed with chezmoi

## Preparation

- Select language
- Select timezone
- Connect to internet
- Login to steam account
- Click through the tutorial
- Click cogwheel icon an `Apply` Software Update
- Restart
- Steam menu -> Power -> Switch to Desktop
- Skip KDE Welcome tutorial

## Install

- there are two paths. Either with `git clone` or having the project on the usb drive and copying from there
- open terminal and execute

```bash
cd <desiredPath>
git clone https://github.com/MyNameIs-13/steamdeck_install
# or
cp -r <pathOnUsb>/steamdeck_install <desiredPath>
```

- followed by

```bash
cd steamdeck_install
chmod +x install.sh
./install.sh
```

- follow on screen instructions
