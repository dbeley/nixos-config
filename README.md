# nixos-config

[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

![t470s](imgs/t470s.png)

| Type           | Program                           |
|----------------|-----------------------------------|
| **Shell:**     | fish                              |
| **DM:**        | tty1                              |
| **WM:**        | hyprland or sway + waybar         |
| **Editor:**    | doom-emacs                        |
| **Terminal:**  | alacritty                         |
| **Launcher:**  | tofi                              |
| **Browser:**   | firefox                           |
| **GTK Theme:** | FlatColor managed by wpgtk+pywal  |

## Hosts

- **t470s**: my main laptop, a Lenovo Thinkpad T470s (i5 6300U, 8Gb RAM, hyprland)
- **x61s**: my retro laptop, a Lenovo Thinkpad X61s (Core 2 duo L7500, 3Gb RAM, sway)
- **chuwi**: a Chuwi Herobox mini-PC (Celeron N4100, 8Gb RAM, hyprland)

## Usage

Rebuild the system

```
sudo nixos-rebuild switch --flake .#{host}
```

Delete unused packages

```
sudo nix-collect-garbage -d
```

## Post-install

```
wpg -a wall.jpg # add wallpaper to wpgtk
wpg-install.sh -g # install gtk theme
wpg -m
```

## Install

On a new install, you should first copy `/etc/nixos/hardware-configuration.nix` over `hosts/{host}/hardware-configuration.nix`.
