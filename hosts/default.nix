{
  lib,
  inputs,
  system,
  user,
  ...
}:
{
  p14s = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user inputs;
      hostName = "p14s";
      stateVersion = "24.05";
    };
    modules = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      inputs.stylix.nixosModules.stylix
      ./p14s/hardware-configuration.nix
      ../modules/configuration.nix
      ../modules/common/uefi.nix
      ../modules/common/laptop.nix
      ../modules/common/xbox.nix
      ../modules/common/fingerprint-scanner.nix
      # ../apps/gnome/default.nix
      ../apps/docker/default.nix
      ../apps/steam/default.nix
      ../apps/udiskie/default.nix
      ../apps/android/default.nix
      ../apps/stylix/default.nix

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit user inputs system;
            stateVersion = "24.05";
          };
          users.${user} = {
            imports = [ (import ./p14s/home.nix) ];
          };
        };
      }
    ];
  };
  x1yoga = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user inputs;
      hostName = "x1yoga";
      stateVersion = "24.05";
    };
    modules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      inputs.stylix.nixosModules.stylix
      ./x1yoga/hardware-configuration.nix
      ../modules/configuration.nix
      ../modules/common/uefi.nix
      ../modules/common/laptop.nix
      ../modules/common/xbox.nix
      ../modules/common/fingerprint-scanner.nix
      ../modules/common/screen-rotation.nix
      # ../apps/gnome/default.nix
      ../apps/docker/default.nix
      ../apps/steam/default.nix
      ../apps/udiskie/default.nix
      ../apps/android/default.nix
      ../apps/stylix/default.nix

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit user inputs system;
            stateVersion = "24.05";
          };
          users.${user} = {
            imports = [ (import ./x1yoga/home.nix) ];
          };
        };
      }
    ];
  };
  latitude = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user inputs;
      hostName = "latitude";
      stateVersion = "24.05";
    };
    modules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      inputs.stylix.nixosModules.stylix
      ./latitude/hardware-configuration.nix
      ../modules/configuration.nix
      ../modules/common/uefi.nix
      ../modules/common/laptop.nix
      ../modules/common/fingerprint-scanner.nix
      ../modules/common/printing.nix
      ../modules/common/zoom-overlay.nix
      ../apps/gnome/default.nix
      ../apps/docker/default.nix
      ../apps/udiskie/default.nix
      ../apps/stylix/default.nix

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit user inputs system;
            stateVersion = "24.05";
          };
          users.${user} = {
            imports = [ (import ./latitude/home.nix) ];
          };
        };
      }
    ];
  };
  sg13 = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user inputs;
      hostName = "sg13";
      stateVersion = "22.11";
    };
    modules = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      inputs.stylix.nixosModules.stylix
      ./sg13/hardware-configuration.nix
      ../modules/configuration.nix
      ../modules/common/uefi.nix
      ../modules/common/xbox.nix
      ../apps/gnome/default.nix
      ../apps/steam/default.nix
      ../apps/udiskie/default.nix
      ../apps/stylix/default.nix

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit user inputs system;
            stateVersion = "22.11";
          };
          users.${user} = {
            imports = [ (import ./sg13/home.nix) ];
          };
        };
      }
    ];
  };
  x61s = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user inputs;
      hostName = "x61s";
      stateVersion = "22.11";
    };
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x200s
      ./x61s/hardware-configuration.nix
      ../modules/configuration.nix
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
            inherit user inputs system;
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
    inherit system;
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
      ../modules/common/uefi.nix
      ../apps/gnome/default.nix

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit user inputs system;
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
