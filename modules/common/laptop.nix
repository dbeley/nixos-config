{
  powerManagement = {
    enable = true;
    powertop.enable = false;
    cpuFreqGovernor = "schedutil";
  };
  services = {
    power-profiles-daemon.enable = false;
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
