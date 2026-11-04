{
  lib,
  pkgs,
  ...
}:
{
  hardware.mnt-pocket-reform = {
    enable = true;
  };

  boot.tmp.useTmpfs = lib.mkForce false;

  boot.kernelParams = [ "fbcon=rotate:3" ];

  zramSwap.memoryPercent = lib.mkForce 50;

  services.fprintd.enable = lib.mkForce false;

  services.blueman.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    alsa-utils
    usbutils
    pciutils
    iw
    tcpdump
    lm_sensors
  ];
}
