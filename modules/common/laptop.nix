{
  powerManagement = {
    enable = true;
    powertop.enable = false;
    cpuFreqGovernor = "schedutil";
  };
  services = {
    power-profiles-daemon.enable = false;
    upower.enable = true;
    tuned = {
      enable = true;
      settings = {
        sleep_interval = 20;
        update_interval = 60;
      };
    };
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
