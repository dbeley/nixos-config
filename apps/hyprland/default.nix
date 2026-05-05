{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    configPackages = [ pkgs.hyprland ];
  };
}
