{
  pkgs,
  inputs,
  ...
}:
let
  batteryMonitor = inputs.battery-monitor.packages.${pkgs.system}.default;
in
{
  environment.systemPackages = [ batteryMonitor ];

  systemd.user.services.battery-monitor = {
    description = "Collect battery metrics";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${batteryMonitor}/bin/battery-monitor-collect";
    };
  };

  systemd.user.timers.battery-monitor = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/10";
      Persistent = true;
    };
  };
}
