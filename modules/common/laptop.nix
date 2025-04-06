{
  powerManagement.enable = true;
  hardware.bluetooth = {
    enable = true;
  };
  services.blueman.enable = true;
  services.logind = {
    lidSwitch = "ignore";
    powerKey = "ignore";
  };
}
