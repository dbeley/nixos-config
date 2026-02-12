{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    beets
    btop
    feishin
    # musescore
    nautilus
    shotcut
    papers
    # supersonic
  ];

  programs.niri.settings.outputs.eDP-1.scale = lib.mkForce 2.0;

  programs.hyprlock.settings.label.font_size = lib.mkForce 100;
}
