{
  pkgs,
  ...
}:
{
  environment.pathsToLink = [ "/share/xdg-desktop-portal" ];

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = [ pkgs.niri ];
  services.displayManager.sessionPackages = [ pkgs.niri ];
}
