{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    beets
    musescore
    nautilus
    shotcut
    supersonic
  ];

  programs.niri.settings.outputs."Dell Inc. DELL S2721DGF 6C1TR83".mode.refresh = lib.mkForce 59.951;
  programs.hyprlock.settings.auth.fingerprint.enabled = lib.mkForce false;
  services.hypridle.enable = lib.mkForce false;
}
