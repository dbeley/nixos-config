{
  xdg.configFile."wal/templates/mako".source = ./mako;
  xdg.configFile."wal/templates/hyprpaper".source = ./hyprpaper;
  xdg.configFile."wal/templates/tofi".source = ./tofi;
  programs.pywal = {
    enable = true;
  };
}
