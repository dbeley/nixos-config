{
  xdg.configFile = {
    "wal/templates/mako".source = ./mako;
    "wal/templates/hyprpaper".source = ./hyprpaper;
    "wal/templates/tofi".source = ./tofi;
  };
  programs.pywal = { enable = true; };
}
