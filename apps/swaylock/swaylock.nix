{ config, lib, ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {
      font = config.stylix.fonts.sansSerif.name;
      font-size = 18;
      show-failed-attempts = true;
      indicator-idle-visible = true;
      indicator-caps-lock = true;
      indicator-radius = 96;
      indicator-thickness = 8;
    };
  };

  wayland.windowManager.niri.settings = lib.mkIf (config.wayland.windowManager.niri.enable or false) {
    binds = {
      "Mod+Shift+C".spawn = [
        "swaylock"
      ];
    };
  };
}
