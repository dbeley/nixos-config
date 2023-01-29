{ lib, nixpkgs, inputs, system, home-manager, user, hyprland, nix-doom-emacs, ... }:

{
  t470s = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
	      useUserPackages = true;
	      extraSpecialArgs = { inherit user inputs system hyprland nix-doom-emacs; };
	      users.${user} = {
	        imports = [(import ./home.nix)];
          };
        };
      }
    ];
  };
}
