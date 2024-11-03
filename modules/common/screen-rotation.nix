{ inputs, pkgs, ... }:
{
  hardware.sensor.iio.enable = true;
  environment.systemPackages = with pkgs; [
    # iio-sensor-proxy
    inputs.iio-hyprland.packages.${pkgs.system}.default
  ];
}
