{
  imports =
    [
      ../apps/light/light.nix
    ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.tlp.enable = true;
  services.logind.lidSwitch = "ignore";
}
