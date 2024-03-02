{
  lib,
  inputs,
  system,
  user,
  ...
}: {
  t470s = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
      ./t470s/hardware-configuration.nix
      ./t470s/configuration.nix
      ../modules/configuration.nix
      ../modules/common/uefi.nix
      ../modules/common/laptop.nix
      ../apps/docker/default.nix
      ../apps/steam/default.nix
      ../apps/udiskie/default.nix
      ../apps/android/default.nix

      inputs.home-manager.nixosModules.home-manager
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
      ./x13/configuration.nix
      ../modules/configuration.nix
      ../modules/common/uefi.nix
      ../modules/common/laptop.nix
      ../apps/docker/default.nix
      ../apps/steam/default.nix
      ../apps/udiskie/default.nix
      ../apps/android/default.nix

      inputs.home-manager.nixosModules.home-manager
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
      ./sg13/configuration.nix
      ./sg13/autologin.nix
      ./sg13/gamescope.nix
      ../modules/configuration.nix
      ../modules/common/uefi.nix
      # ../apps/gnome/default.nix
      # ../apps/steam/default.nix
      # ../apps/udiskie/default.nix

      # inputs.home-manager.nixosModules.home-manager
      # {
        # home-manager = {
          # useGlobalPkgs = true;
          # useUserPackages = true;
          # extraSpecialArgs = {inherit user inputs system;};
          # users.${user} = {
            # imports = [(import ./sg13/home.nix)];
          # };
        # };
      # }
    ];
  };
  x61s = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x200s
      ./x61s/hardware-configuration.nix
      ./x61s/configuration.nix
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
          extraSpecialArgs = {inherit user inputs system;};
          users.${user} = {
            imports = [(import ./x61s/home.nix)];
          };
        };
      }
    ];
  };
  era1 = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      inputs.disko.nixosModules.disko
      {disko.devices.disk.disk1.device = "/dev/vda";}
      ./era1/hardware-configuration.nix
      ./era1/configuration.nix

      # inputs.home-manager.nixosModules.home-manager
      # {
      #   home-manager = {
      #     useGlobalPkgs = true;
      #     useUserPackages = true;
      #     extraSpecialArgs = {inherit user inputs system;};
      #     users.${user} = {
      #       imports = [(import ./sg13/home.nix)];
      #     };
      #   };
      # }
    ];
  };
}
