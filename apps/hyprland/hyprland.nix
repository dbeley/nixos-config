{
  inputs,
  system,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [mako libnotify hyprpaper grim slurp pamixer];
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
    xwayland.enable = true;
    plugins = [
      inputs.hycov.packages.${system}.hycov
    ];
    extraConfig = lib.fileContents ./hyprland.conf;
  };
}
