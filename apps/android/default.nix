{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.android-tools
  ];
  services.udev.extraRules = ''
    # Samsung (vendor 04e8) and Motorola (vendor 22b8) adb access
    SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", MODE="0666"
  '';
}
