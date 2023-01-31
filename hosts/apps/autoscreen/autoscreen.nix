{ pkgs, user, ... }:

{
  home.file = {
  "Documents/autoscreen".source = pkgs.fetchFromGitHub {
     owner = "dbeley";
     repo = "autoscreen";
     rev = "d6aaef67f535b9c1ab3be15b29cbd00bd62e49d8";
     sha256 = "WfA0Lc0Z6ogxRWHSSX24yMup6OFKJ5cBIBMXjTvyL/8=";
    };
  };

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
      WorkingDirectory = "%h/Documents/autoscreen";
      ExecStart = "autoscreen_wayland.sh";
    };
    Install = {
      WantedBy = [ "multi-user.target" ];
    };
  };
}
