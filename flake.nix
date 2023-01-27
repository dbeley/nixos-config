{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, hyprland, ... }:
    let
      system = "x86_64-linux";
      user = "david";
      pkgs = import nixpkgs {
        inherit system;
	    config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = (
        import ./hosts {
	      inherit (nixpkgs) lib;
	      inherit inputs user system home-manager hyprland;
	    }
      );
      #homeConfigurations."david@t470s" = home-manager.lib.homeManagerConfiguration {
      #  pkgs = nixpkgs.legacyPackages.x86_64-linux;

      #  modules = [
      #    hyprland.homeManagerModules.default
      #    {wayland.windowManager.hyprland.enable = true;}
      #  ];
      #};
    };
}
