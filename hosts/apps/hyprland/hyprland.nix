{
  pkgs,
  lib,
  ...
}: let
  newHyprpaper = pkgs.hyprpaper.overrideAttrs (old: {
    version = "git";
    src = pkgs.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprpaper";
      rev = "61961973cfd10853b32c7f904cdb88f9ab6d84dd";
      sha256 = "FHhBetkV/S7M9BMpbCzUWX/P5E7tGE4mZIpj/2m0K2M=";
    };
  });
in {
  home.packages = with pkgs; [mako libnotify newHyprpaper grim slurp pamixer];
  home.file.".local/bin/wrappehl".source = ./wrappedhl;
  home.file = {
    "scripts".source = pkgs.fetchFromGitHub {
      owner = "dbeley";
      repo = "scripts";
      rev = "705634a4832ac15df0df0319ce6048621afd6cc2";
      sha256 = "KWouJA2I0gVDjNwASI7sz3XrfyGQPwe6oqZ7mjjIw78=";
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
    extraConfig = lib.fileContents ./hyprland.conf;
  };
}
