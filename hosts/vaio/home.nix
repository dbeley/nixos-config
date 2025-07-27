{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    beets
    nautilus
    supersonic
  ];

  programs.niri.settings.outputs."Dell Inc. DELL S2721DGF 6C1TR83".mode.refresh = lib.mkForce 59.951;
}
