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
    # musescore
    nautilus
    shotcut
    papers
    supersonic
  ];

  programs.niri.settings.outputs.eDP-1.scale = lib.mkForce 1.5;
}
