{ lib, ... }:
{
  environment.etc."throttled.conf".text = lib.mkForce ''
    [GENERAL]
    Enabled: True
    Sysfs_Power_Path: /sys/class/power_supply/AC*/online
    Autoreload: True

    [BATTERY]
    Update_Rate_s: 30
    PL1_Tdp_W: 10
    PL1_Duration_s: 28
    PL2_Tdp_W: 20
    PL2_Duration_S: 28
    Trip_Temp_C: 85
    cTDP: 0
    Disable_BDPROCHOT: False

    [AC]
    Update_Rate_s: 30
    PL1_Tdp_W: 40
    PL1_Duration_s: 28
    PL2_Tdp_W: 40
    PL2_Duration_S: 28
    Trip_Temp_C: 85
    cTDP: 0
    Disable_BDPROCHOT: False
  '';
}
