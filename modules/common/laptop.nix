{
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services = {
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        STOP_CHARGE_THRESH_BAT0 = 95;
        USB_AUTOSUSPEND = "1";
        USB_DENYLIST = "25a7:fa7b";
      };
    };
  };
  hardware.bluetooth = {
    enable = true;
  };
  services.blueman.enable = true;
  services.logind = {
    lidSwitch = "ignore";
    powerKey = "ignore";
  };
}
