{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    iio-sensor-proxy
  ];
  hardware.sensor.iio.enable = true;
}
