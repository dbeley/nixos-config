# nixos-config

[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

| Type           | Program                           |
|----------------|-----------------------------------|
| **Shell:**     | fish                              |
| **DM:**        | tty1                              |
| **WM:**        | hyprland + waybar                 |
| **Editor:**    | doom-emacs                        |
| **Terminal:**  | alacritty                         |
| **Launcher:**  | wofi                              |
| **Browser:**   | firefox                           |
| **GTK Theme:** | FlatColor managed by wpgtk+pywal  |

## Hosts

- **t470s**: my main computer, a Lenovo Thinkpad T470s (i5 6300U, 8Gb RAM)

## Usage

Rebuild the system

```
sudo nixos-rebuild switch --flake .#{name}
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

On a new install, you should first copy `/etc/nixos/hardware-configuration.nix` over `hosts/hardware-configuration.nix`.
