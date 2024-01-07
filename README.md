# nixos-config

[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

![t470s](imgs/t470s.png)

| Type           | Program                                  |
|----------------|------------------------------------------|
| **Shell:**     | fish                                     |
| **DM:**        | tty1                                     |
| **WM:**        | hyprland or sway + waybar                |
| **Editor:**    | doom-emacs or neovim (managed by nixvim) |
| **Terminal:**  | kitty                                    |
| **Launcher:**  | tofi                                     |
| **Browser:**   | firefox                                  |
| **GTK Theme:** | wpgtk + pywal                            |

## Hosts

- **x13**: my main laptop (Lenovo ThinkPad X13 Gen 1: Ryzen 5 4650U, 16GB RAM, hyprland)
- **sg13**: my main desktop computer (Silverstone SG13: Ryzen 5 2600, RX 580 8GB, 16GB RAM, gnome)
- **t470s**: my previous main laptop (Lenovo Thinkpad T470s: Intel Core i5-6300U, 8GB RAM, hyprland)
- **x61s**: my retro laptop (Lenovo Thinkpad X61s: Intel Core 2 Duo L7500, 3GB RAM, sway)
- **era1**: my first server image installed in a Proxmox VM (Fractal Design Era: Intel N100, 32GB RAM)

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
wpg -a wall.jpg # add wallpaper to wpgtk
wpg-install.sh -g # install gtk theme
wpg -m
```

```
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
```
