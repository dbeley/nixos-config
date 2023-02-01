{ pkgs, ... }:

let
  autoscreen = pkgs.writeShellScriptBin "autoscreen" (builtins.readFile ./autoscreen.sh);
in
{
  home.packages = with pkgs; [ autoscreen ];

  systemd.user.timers."autoscreen" = {
    Unit = {
      Description = "Run autoscreen every hour at random";
    };
    Timer = {
      OnCalendar = "hourly";
      RandomizedDelaySec = 3600;
      AccuracySec = "1us";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.services."autoscreen" = {
    Unit = {
      Description = "Take a screenshot with grim";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${autoscreen}/bin/autoscreen";
    };
    Install = {
      WantedBy = [ "multi-user.target" ];
    };
  };
}
