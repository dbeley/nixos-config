{ lib, inputs, system, home-manager, user, hyprland, ... }:

{
  t470s = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.extraSpecialArgs = { inherit user; };
	home-manager.users.${user} = {
	  imports = [(import ./home.nix)];
        };
      }
    ];
  };
}
