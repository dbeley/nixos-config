{
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.sway ];
  services.displayManager.sessionPackages = [ pkgs.sway ];
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.sway.default = [ "gtk" ];
  };
  environment.sessionVariables = {
    GTK_IM_MODULE = "simple";
  };
}
