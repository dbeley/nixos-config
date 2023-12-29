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

- **x13**: my main laptop, a Lenovo Thinkpad X13 (Ryzen 5 4650U, 16Gb RAM, hyprland)
- **sg13**: my main desktop computer, in a Silverstone SG13 Mini-ITX case (Ryzen 5 2600, RX 580 8Gb, 16Gb RAM, gnome)
- **t470s**: my previous main laptop, a Lenovo Thinkpad T470s (i5 6300U, 8Gb RAM, hyprland)
- **x61s**: my retro laptop, a Lenovo Thinkpad X61s (Core 2 duo L7500, 3Gb RAM, sway)

## Usage

Rebuild the system

```
sudo nixos-rebuild switch --flake .#{host}
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
