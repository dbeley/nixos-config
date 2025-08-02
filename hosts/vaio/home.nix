{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    audacity
    beets
    nautilus
    supersonic
  ];

  programs.niri.settings.outputs."Dell Inc. DELL S2721DGF 6C1TR83".mode.refresh = lib.mkForce 59.951;

  # Disable fingerprint authentication in hyprlock to avoid
  # wake-from-sleep issues on the VAIO host.
  programs.hyprlock.settings.auth.fingerprint.enabled = lib.mkForce false;
}
