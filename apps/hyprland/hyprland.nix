{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
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
    ".config/hypr/hyprpaper.conf" = {
      text = ''
      preload=${config.stylix.image}
      wallpaper=eDP-1,${config.stylix.image}
      wallpaper=DP-3,${config.stylix.image}
      wallpaper=DP-5,${config.stylix.image}
      wallpaper=HDMI-A-1,${config.stylix.image}
      splash=false
      '';
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = lib.fileContents ./hyprland.conf;
    # plugins = [ inputs.hyprspace.packages.${pkgs.system}.Hyprspace ];
  };
}
