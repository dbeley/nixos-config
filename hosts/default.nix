{ lib, nixpkgs, inputs, system, home-manager, user, hyprland, ... }:

{
  t470s = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      ./configuration.nix
      hyprland.nixosModules.default
      ./desktop/hyprland/hyprland.nix

      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
	      useUserPackages = true;
	      extraSpecialArgs = { inherit user inputs system hyprland; };
	      users.${user} = {
	        imports = [(import ./home.nix)];
          };
        };
      }
    ];
  };
}
