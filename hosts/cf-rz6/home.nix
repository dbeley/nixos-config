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
  dconf.settings = {
    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = lib.mkForce true;
    };
    "org/gnome/desktop/interface" = {
      toolkit-accessibility = lib.mkForce true;
    };
  };

  programs.niri.settings.outputs.eDP-1.scale = lib.mkForce 1.5;
}
