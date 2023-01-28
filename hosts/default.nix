{ lib, nixpkgs, inputs, system, home-manager, user, hyprland, ... }:

{
  t470s = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
	      useUserPackages = true;
	      extraSpecialArgs = { inherit user inputs system; };
	      users.${user} = {
	        imports = [(import ./home.nix)];
          };
        };
      }
    ];
  };
}
