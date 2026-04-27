{
  powerManagement = {
    enable = true;
    powertop.enable = false;
  };
  services = {
    power-profiles-daemon.enable = true;
    tlp.enable = false;
    upower.enable = true;
  };
  hardware.bluetooth = {
    enable = true;
  };
  services.blueman.enable = true;
  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "ignore";
        HandlePowerKey = "ignore";
      };
    };
  };
}
