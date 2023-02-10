{
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
      rev = "2cacaa24ca91cb74f8d3a371adaf426765ed76bc";
      sha256 = "VGu7Oz2B+XDSZHe7LcP+3tK1Qlet4pNXc4F1ZpC50aY=";
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    extraConfig = lib.fileContents ./hyprland.conf;
  };
}
