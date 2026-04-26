{ pkgs, ... }:
{
  programs.niri.package = pkgs.niri-unstable;

  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    configPackages = [ pkgs.niri-unstable ];
  };
}
