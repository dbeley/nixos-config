{
  pkgs,
  inputs,
  ...
}:
let
  symmetri = inputs.symmetri.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  environment.systemPackages = [ symmetri ];

  systemd.user.services.symmetri = {
    description = "symmetri - Collect computer metrics";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${symmetri}/bin/symmetri-collect";
    };
  };

  systemd.user.timers.symmetri = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/5";
      Persistent = true;
    };
  };
}
