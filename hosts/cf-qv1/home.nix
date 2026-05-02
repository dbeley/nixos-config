{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # audacity
    beets
    feishin
    # musescore
    nautilus
    # shotcut
    papers
    # supersonic
  ];

  # CF-QV1 specific settings
  # 3880x1920 screen needs higher scaling and font size
  wayland.windowManager.niri.settings.output = lib.mkForce [
    {
      _args = [ "eDP-1" ];
      scale = 2.0;
    }
  ];
  programs.hyprlock.settings.label.font_size = lib.mkForce 100;
  # Increase trackpad sensitivity for the smaller trackpad
  wayland.windowManager.niri.settings.input.touchpad."accel-speed" = 0.4;
}
