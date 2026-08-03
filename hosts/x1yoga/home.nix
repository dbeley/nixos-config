{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    # audacity
    beets
    # discord
    # heroic
    # jamulus
    # musescore
    nautilus
    papers
    # shotcut
    # transcribe
    wvkbd
  ];
  dconf.settings = {
    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = lib.mkForce true;
    };
    "org/gnome/desktop/interface" = {
      toolkit-accessibility = lib.mkForce true;
    };
  };
}
