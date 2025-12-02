{ lib, ... }:
{
  environment.etc."throttled.conf".text = lib.mkForce ''
    [GENERAL]
    Enabled: True
    Sysfs_Power_Path: /sys/class/power_supply/AC*/online
    Autoreload: True

    [BATTERY]
    Update_Rate_s: 60
    PL1_Tdp_W: 10
    PL1_Duration_s: 60
    PL2_Tdp_W: 10
    PL2_Duration_S: 60
    Trip_Temp_C: 90
    cTDP: 0
    Disable_BDPROCHOT: False

    [AC]
    Update_Rate_s: 60
    PL1_Tdp_W: 10
    PL1_Duration_s: 60
    PL2_Tdp_W: 10
    PL2_Duration_S: 60
    Trip_Temp_C: 90
    cTDP: 0
    Disable_BDPROCHOT: False
  '';
}
