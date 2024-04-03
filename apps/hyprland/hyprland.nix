{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    mako
    libnotify
    hyprpaper
    grim
    slurp
    pamixer
  ];
  home.file.".local/bin/wrappedhl".source = ./wrappedhl;
  home.file = {
    "scripts".source = pkgs.fetchFromGitHub {
      owner = "dbeley";
      repo = "scripts";
      rev = "a8607fbfb8c50543629e14ec483473459229091d";
      sha256 = "XBumWlu4+z/jTKLK71Lr0hMeLhc43XD3oEzY+YUMzN4=";
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = lib.fileContents ./hyprland.conf;
  };
}
