{
  config,
  lib,
  osConfig,
  ...
}:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      auth = {
        pam = {
          enabled = true;
        };
        fingerprint = {
          enabled = osConfig.services.fprintd.enable;
        };
      };
      label = {
        text = "$TIME";
        font_size = 50;
        position = "0, 100";
        halign = "center";
        valign = "center";
      };
    };
  };
  wayland.windowManager.niri.settings = lib.mkIf (config.wayland.windowManager.niri.enable or false) {
    binds = {
      "Mod+Shift+C".spawn = [
        "hyprlock"
      ];
    };
  };
}
