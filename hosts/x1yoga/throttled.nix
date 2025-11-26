{
  config,
  lib,
  pkgs,
  ...
}:
let
  throttledConfig = ''
[GENERAL]
Enabled: True
Sysfs_Power_Path: /sys/class/power_supply/AC*/online
Autoreload: True

[BATTERY]
Update_Rate_s: 30
PL1_Tdp_W: 25
PL1_Duration_s: 28
PL2_Tdp_W: 35
PL2_Duration_S: 0.002
Trip_Temp_C: 85
cTDP: 0
Disable_BDPROCHOT: False

[AC]
Update_Rate_s: 5
PL1_Tdp_W: 35
PL1_Duration_s: 30
PL2_Tdp_W: 55
PL2_Duration_S: 0.002
Trip_Temp_C: 95
cTDP: 0
Disable_BDPROCHOT: False

[UNDERVOLT.BATTERY]
CORE: -50
GPU: -50
CACHE: -50
UNCORE: -50
ANALOGIO: 0

[UNDERVOLT.AC]
CORE: -50
GPU: -50
CACHE: -50
UNCORE: -50
ANALOGIO: 0
  '';
in
{
  environment.etc."throttled.conf".text = throttledConfig;

  systemd.packages = [ pkgs.throttled ];

  systemd.services.throttled = {
    wantedBy = [ "multi-user.target" ];
    restartTriggers = [ config.environment.etc."throttled.conf".source ];
    unitConfig = {
      Description = "Stop Intel CPU power throttling";
    };
    serviceConfig = {
      Restart = "always";
      RestartSec = 5;
    };
  };
}
