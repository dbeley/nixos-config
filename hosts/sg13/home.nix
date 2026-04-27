{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    beets
    feishin
    nautilus
    papers
    # supersonic
  ];

  programs.btop.package = pkgs.btop-cuda;

  # disable night light in Gnome
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = lib.mkForce false;
    };
  };
}
