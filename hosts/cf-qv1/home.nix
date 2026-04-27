{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    beets
    feishin
    # musescore
    nautilus
    shotcut
    papers
    # supersonic
  ];

  wayland.windowManager.niri.settings.output = lib.mkForce [
    {
      _args = [ "eDP-1" ];
      scale = 2.0;
    }
  ];

  programs.hyprlock.settings.label.font_size = lib.mkForce 100;
}
