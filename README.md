# nixos-config

[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

![t470s](imgs/t470s.png)

| Type           | Program                                  |
|----------------|------------------------------------------|
| **Shell:**     | fish                                     |
| **DM:**        | tty1                                     |
| **WM:**        | hyprland or sway + waybar                |
| **Editor:**    | doom-emacs / neovim / helix / kakoune    |
| **Terminal:**  | ghostty / kitty                          |
| **Launcher:**  | tofi                                     |
| **Browser:**   | firefox / qutebrowser                    |
| **Theme:**     | stylix                                   |

## Hosts

- **p14s**: my main laptop (Lenovo ThinkPad P14s Gen 4: AMD Ryzen 7 7840U, 16GB RAM, hyprland)
- **x1yoga**: my secondary laptop (Lenovo ThinkPad X1 Yoga Gen 5: Intel Core i5-10210U, 8GB RAM, hyprland + touch gestures w/ hyprgrass, impermanence)
- **sg13**: my main desktop computer (Silverstone SG13: AMD Ryzen 5 2600, RX 580 8GB, 16GB RAM, gnome)
- **x61s**: my retro laptop (Lenovo Thinkpad X61s: Intel Core 2 Duo L7500, 3GB RAM, sway)
- **x13**: my previous main laptop (Lenovo ThinkPad X13 Gen 1: AMD Ryzen 5 4650U, 16GB RAM, hyprland, impermanence)
- (deprecated) **t470s**: my previous main laptop (Lenovo Thinkpad T470s: Intel Core i5-6300U, 8GB RAM, hyprland)
- (deprecated) **era1**: my first server image installed in a Proxmox VM (Fractal Design Era: Intel N100, 32GB RAM)

## Usage

Rebuild the system

```
sudo nixos-rebuild switch --flake .#{host}
sudo nixos-rebuild switch --flake .#{host} --target-host root@<ip address> # for a remote host
```

Delete unused packages

```
sudo nix-collect-garbage -d # for system packages
nix-collect-garbage -d # for home-manager packages
```

Optimise store

```
nix-store --optimise -v
```

## Install

On a new install, you should first copy `/etc/nixos/hardware-configuration.nix` over `hosts/{host}/hardware-configuration.nix`.

## Post-install

```
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
```

### just

A `justfile` is also provided, see https://github.com/casey/just for more information.

```
just switch
just clean
```

Create a `.env` and fill it with the needed environment variables:

```
HOST=x13
````

## Impermanence

Installation can be done from any computer running nix, using a live ISO running from a USB key is not recommended as it will most likely run out of space during the install.
The target disk can be any mounted disk (except the one the system is currently running on!) and will then have to be installed on the host compuster after the installation is complete.
:

```
# On a new host don't forget to generate the hardware-configuration.nix file
nixos-generate-config --no-filesystems
# Existing host called "x1yoga"
sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake .#x1yoga --disk main /dev/sda --show-trace

# post-installation 
lsblk # identify luks encrypted partition
sudo cryptsetup open /dev/sda2 luks-1
sudo mount -o subvol=root /dev/mapper/luks-1 /mnt/root
sudo mount -o subvol=persistent /dev/mapper/luks-1 /mnt/root/persistent  
sudo mount -o subvol=nix /dev/mapper/luks-1 /mnt/root/nix
sudo mount /dev/sda1 /mnt/root/boot

# create password file
mkpasswd > temp_passwd_file
sudo mv temp_passwd_file /mnt/root/persistent/passwd_$USER
sudo chown root:root /mnt/root/persistent/passwd_$USER

# to fix bug where home-manager can't create user home directory
sudo mkdir -p /mnt/root/persistent/home/$USER
sudo chown $USER:users /mnt/root/persistent/home/$USER

# chroot into the new system
sudo nixos-enter --root /mnt
```

## Notable Features

- Support for multiple desktop environments (hyprland, gnome, sway)
- Extensive Hyprland configuration
- Hyprland configuration to properly support touchscreen with gestures, rotation and on-screen keyboard
- Automatic styling with `stylix`
- Extensive Firefox configuration with `about:config` settings and automatic add-ons installaiton
- Declarative partitioning with `disko`
- Epheremeal file system with `impermanence` on btrfs subvolumes
- Configuration for common hardware with `nixos-hardware`
- Automatic microcode updates for AMD CPUs with `ucodenix`
- Automatic development shells with `direnv` and `shell.nix`
- My own custom packages including `autoscreen` (tool to take screenshots randomly each hour) and `mpdscrobble` (utility to send MPD listening history to Last.fm)
- mpv configuration with plugins
- nnn configuration with plugins and bookmarks
- Extensive qutebrowser configuration with search engines
- Support for fingerprint scanner, printers, bluetooth, xbox gamepad
- Some common overlays that fix currently broken packages
- flatpak with automatic Steam installation

## TODO

Some tools and utilities to test

- sops-nix
- nixos-generators
- git-hooks
- niri windows manager
