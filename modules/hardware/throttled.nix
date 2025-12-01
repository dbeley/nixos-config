{
  config,
  lib,
  pkgs,
  ...
}:
let
  defaultConfig = ''
    [GENERAL]
    Enabled: True
    Sysfs_Power_Path: /sys/class/power_supply/AC*/online
    Autoreload: True
  '';
in
{
  config = {
    environment.etc."throttled.conf".text = lib.mkDefault defaultConfig;

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
  };
}
