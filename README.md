# nixos-config

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
