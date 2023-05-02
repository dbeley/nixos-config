{
  lib,
  nixpkgs,
  inputs,
  system,
  home-manager,
  user,
  hyprland,
  nix-doom-emacs,
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
      # compatibility with hyprland
      ./apps/waybar/default.nix
      ./apps/docker/default.nix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system hyprland nix-doom-emacs;};
          users.${user} = {
            imports = [(import ./t470s/home.nix)];
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

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system hyprland nix-doom-emacs;};
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
      # compatibility with hyprland
      ./apps/waybar/default.nix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs system hyprland nix-doom-emacs;};
          users.${user} = {
            imports = [(import ./chuwi/home.nix)];
          };
        };
      }
    ];
  };
}
