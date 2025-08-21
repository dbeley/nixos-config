{ inputs, pkgs, ... }:
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    # iio-sensor-proxy
    inputs.iio-hyprland.packages.${pkgs.system}.default
  ];
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };
}
