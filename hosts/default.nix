{ lib, nixpkgs, inputs, system, home-manager, user, hyprland, nix-doom-emacs, ... }:

{
  t470s = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
      ./t470s/hardware-configuration.nix
      ./configuration.nix
      ./laptop.nix

      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
	      useUserPackages = true;
	      extraSpecialArgs = { inherit user inputs system hyprland nix-doom-emacs; };
	      users.${user} = {
	        imports = [(import ./t470s/home.nix)];
          };
        };
      }
    ];
  };
  x61s = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x200s
      ./x61s/hardware-configuration.nix
      ./configuration.nix
      ./laptop.nix

      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
	      useUserPackages = true;
	      extraSpecialArgs = { inherit user inputs system hyprland nix-doom-emacs; };
	      users.${user} = {
	        imports = [(import ./x61s/home.nix)];
          };
        };
      }
    ];
  };

}
