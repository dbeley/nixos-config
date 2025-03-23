{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };
}
