{
  lib,
  inputs,
  system,
  home-manager,
  user,
  hyprland,
  nixvim,
  ...
}: {
  t470s = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
      ./t470s/hardware-configuration.nix
      ./configuration.nix
      ./common/uefi.nix
      ./common/laptop.nix
      ./apps/docker/default.nix
      ./apps/steam/default.nix
      ./apps/udiskie/default.nix
      ./apps/android/default.nix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system hyprland nixvim;};
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
      ./configuration.nix
      ./common/uefi.nix
      ./common/laptop.nix
      ./apps/docker/default.nix
      ./apps/steam/default.nix
      ./apps/udiskie/default.nix
      ./apps/android/default.nix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system hyprland nixvim;};
          users.${user} = {
            imports = [(import ./x13/home.nix)];
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
      ./configuration.nix
      ./common/bios.nix
      ./common/laptop.nix
      ./apps/swaylock/default.nix
      ./apps/steam/default.nix
      ./apps/udiskie/default.nix
      ./apps/android/default.nix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system hyprland nixvim;};
          users.${user} = {
            imports = [(import ./x61s/home.nix)];
          };
        };
      }
    ];
  };
  chuwi = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./chuwi/hardware-configuration.nix
      ./configuration.nix
      ./common/uefi-no-encryption.nix
      ./apps/steam/default.nix
      ./apps/udiskie/default.nix
      ./apps/android/default.nix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system hyprland nixvim;};
          users.${user} = {
            imports = [(import ./chuwi/home.nix)];
          };
        };
      }
    ];
  };
}
