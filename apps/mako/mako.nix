{ lib, config, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      layer = "overlay";
      width = 300;
      height = 100;
      icons = true;
      margin = "10";
      padding = "8";
      border-size = 3;
      border-radius = 5;
      default-timeout = 5000;
    };
  };

  wayland.windowManager.niri.settings = lib.mkIf (config.wayland.windowManager.niri.enable or false) {
    _children = [
      { spawn-at-startup = [ "mako" ]; }
    ];
  };
}
