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
    hostname = "latitude";
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
  sg13 = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit user inputs;
      hostName = "sg13";
      stateVersion = "24.11";
    };
    modules = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      inputs.stylix.nixosModules.stylix
      ../apps/stylix/default.nix
      ./sg13/hardware-configuration.nix
      ../modules/configuration.nix
      ../modules/overlays.nix
      ../modules/common/bootloader-grub.nix
      ../modules/common/xbox.nix
      ../apps/gnome/default.nix
      ../apps/steam/default.nix
      ../apps/udiskie/default.nix

      {
        my.stylix.wallpaper = "hk-plant";
      }

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit user inputs;
            system = "x86_64-linux";
            stateVersion = "24.11";
          };
          users.${user} = {
            imports = [ (import ./sg13/home.nix) ];
          };
        };
      }
    ];
  };
  x61s = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit user inputs;
      hostName = "x61s";
      stateVersion = "22.11";
    };
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x200s
      ./x61s/hardware-configuration.nix
      ../modules/configuration.nix
      ../modules/overlays.nix
      ../modules/common/bios.nix
      ../modules/common/laptop.nix
      ../apps/swaylock/default.nix
      ../apps/steam/default.nix
      ../apps/udiskie/default.nix
      ../apps/android/default.nix

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit user inputs;
            system = "x86_64-linux";
            stateVersion = "22.11";
          };
          users.${user} = {
            imports = [ (import ./x61s/home.nix) ];
          };
        };
      }
    ];
  };
  nixos-example = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit user inputs;
      hostName = "nixos-example";
      stateVersion = "24.05";
    };
    modules = [
      # Uncomment based on the CPU of you machine
      # inputs.nixos-hardware.nixosModules.common-cpu-amd
      # inputs.nixos-hardware.nixosModules.common-cpu-intel

      # Uncomment if you have a laptop
      # inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      # ../modules/common/laptop.nix

      # Uncomment the system apps you want
      # ../apps/docker/default.nix
      # ../apps/steam/default.nix
      # ../apps/udiskie/default.nix
      # ../apps/android/default.nix

      ./nixos-example/hardware-configuration.nix
      ../modules/configuration.nix
      ../modules/overlays.nix
      ../modules/common/bootloader-systemd-boot.nix
      ../apps/gnome/default.nix

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit user inputs;
            system = "x86_64-linux";
            stateVersion = "24.05";
          };
          users.${user} = {
            imports = [ (import ./nixos-example/home.nix) ];
          };
        };
      }
    ];
  };
}
