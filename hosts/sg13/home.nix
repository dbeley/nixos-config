{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    gnome-terminal
    nautilus
    supersonic
  ];

  # disable night light in Gnome
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = lib.mkForce false;
    };
  };
}
