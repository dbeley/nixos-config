{
  imports = [ ../../apps/light/light.nix ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  powerManagement.powertop.enable = true;
  # services.tlp.enable = true;
  services.logind.lidSwitch = "ignore";
}
