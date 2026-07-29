_: {
  # Required by home-manager's xdg.portal when using useUserPackages
  # (wayland.windowManager.niri from home-manager sets up portals)
  environment.pathsToLink = [ "/share/xdg-desktop-portal" ];

  services.gnome.gnome-keyring.enable = true;
}
