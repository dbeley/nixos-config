{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    libnotify
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
    # plugins = [ inputs.hyprspace.packages.${pkgs.system}.Hyprspace ];
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        config.stylix.image
      ];
      wallpaper = [
        "eDP-1,${config.stylix.image}"
        "DP-3,${config.stylix.image}"
        "DP-5,${config.stylix.image}"
        "HDMI-A-1,${config.stylix.image}"
      ];
    };
  };
}
