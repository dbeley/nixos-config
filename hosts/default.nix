{
  lib,
  inputs,
  system,
  home-manager,
  user,
  ...
}: {
  t470s = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
      ./t470s/hardware-configuration.nix
      ../modules/configuration.nix
      ../modules/common/uefi.nix
      ../modules/common/laptop.nix
      ../apps/docker/default.nix
      ../apps/steam/default.nix
      ../apps/udiskie/default.nix
      ../apps/android/default.nix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system;};
          users.${user} = {
            imports = [(import ./t470s/home.nix)];
          };
        };
      }
    ];
  };
  x13 = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      ./x13/hardware-configuration.nix
      ../modules/configuration.nix
      ../modules/common/uefi.nix
      ../modules/common/laptop.nix
      ../apps/docker/default.nix
      ../apps/steam/default.nix
      ../apps/udiskie/default.nix
      ../apps/android/default.nix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system;};
          users.${user} = {
            imports = [(import ./x13/home.nix)];
          };
        };
      }
    ];
  };
  sg13 = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      ./sg13/hardware-configuration.nix
      ../modules/configuration.nix
      ../modules/common/uefi.nix
      ../apps/gnome/default.nix
      ../apps/steam/default.nix
      ../apps/udiskie/default.nix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system;};
          users.${user} = {
            imports = [(import ./sg13/home.nix)];
          };
        };
      }
    ];
  };
  x61s = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
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

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system;};
          users.${user} = {
            imports = [(import ./x61s/home.nix)];
          };
        };
      }
    ];
  };
}
