{
  lib,
  inputs,
  user,
  ...
}:
let
  mkHost =
    {
      hostName,
      stateVersion,
      system ? "x86_64-linux",
      modules ? [ ],
      homeModules ? [ ],
    }:
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          user
          inputs
          hostName
          stateVersion
          ;
      };
      modules = [
        ../modules/configuration.nix
        ../modules/overlays.nix
        ../apps/udiskie/default.nix

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit
                user
                inputs
                system
                stateVersion
                ;
            };
            users.${user} = {
              imports = [
                (import ./${hostName}/home.nix)
              ] ++ homeModules;
            };
          };
        }

        ./${hostName}/hardware-configuration.nix
      ] ++ modules;
    };
  laptopModules = [
    ../modules/common/laptop.nix
    ../modules/common/fingerprint-scanner.nix
  ];
  hyprlandModules = [
    ../apps/hyprland/default.nix
    ../apps/hyprlock/default.nix
  ];
  gnomeModules = [
    ../apps/gnome/default.nix
  ];
  stylixModules = [
    inputs.stylix.nixosModules.stylix
    ../apps/stylix/default.nix
  ];
  impermanenceModules = [
    inputs.disko.nixosModules.disko
    ../modules/disko/encrypted-btrfs-impermanence.nix
    inputs.impermanence.nixosModules.impermanence
    ../modules/impermanence/default.nix
  ];
  niriModules = [
    ../apps/niri/default.nix
    ../apps/hyprlock/default.nix
  ];
  steamModules = [
    ../modules/common/xbox.nix
    ../apps/steam/default.nix
  ];
  dockerModules = [
    ../apps/docker/default.nix
  ];
in
{
  p14s = mkHost {
    hostName = "p14s";
    stateVersion = "24.05";
    modules =
      [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen4
        ../modules/common/bootloader-systemd-boot.nix
        ../apps/android/default.nix
      ]
      ++ laptopModules
      ++ hyprlandModules
      ++ stylixModules
      ++ dockerModules
      ++ steamModules;
  };
  x1yoga = mkHost {
    hostName = "x1yoga";
    stateVersion = "25.05";
    modules =
      [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
        ../modules/common/laptop-thermald.nix
        ../modules/common/bootloader-systemd-boot.nix
        ../modules/common/screen-rotation.nix
        ../apps/android/default.nix
        {
          my.stylix.wallpaper = "purple-waves";
        }
      ]
      ++ laptopModules
      ++ impermanenceModules
      ++ hyprlandModules
      ++ stylixModules
      ++ steamModules;
  };
  x13 = mkHost {
    hostName = "x13";
    stateVersion = "24.11";
    modules =
      [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13-amd
        ../modules/common/bootloader-systemd-boot.nix
        ../apps/android/default.nix
        {
          my.stylix.wallpaper = "nyc-425-park-avenue";
        }
      ]
      ++ laptopModules
      ++ impermanenceModules
      ++ niriModules
      ++ stylixModules
      ++ steamModules;
  };
  latitude = mkHost {
    hostName = "latitude";
    stateVersion = "24.05";
    modules =
      [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.nixos-hardware.nixosModules.common-gpu-intel
        inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
        ../modules/common/bootloader-systemd-boot.nix
        ../modules/common/laptop-thermald.nix
        ../modules/common/printing.nix
        {
          my.stylix.wallpaper = "abstract-light-rays";
        }
      ]
      ++ laptopModules
      ++ niriModules
      ++ stylixModules
      ++ dockerModules;
  };
  sg13 = mkHost {
    hostName = "sg13";
    stateVersion = "24.11";
    modules = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      ./sg13/hardware-configuration.nix
      ../modules/common/bootloader-grub.nix
      {
        my.stylix.wallpaper = "hk-plant";
      }
    ]
    ++ gnomeModules
    ++ stylixModules
    ++ steamModules;
  };
  x61s = mkHost {
    hostName = "x61s";
    stateVersion = "22.11";
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x200s
      ../modules/common/bios.nix
      ../apps/swaylock/default.nix
    ]
    ++ laptopModules ++ steamModules
    ;
  };
}
