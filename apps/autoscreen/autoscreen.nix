{ pkgs, ... }:
let
  autoscreen = pkgs.writeShellScriptBin "autoscreen" ''
    TODAY="$(${pkgs.coreutils-full}/bin/date +%Y-%m-%d)"
    DESTINATION_DIR="$HOME/Nextcloud/10-19_Images/11_Captures-d-écran/11.01_autoscreen/$TODAY"

    ${pkgs.coreutils-full}/bin/mkdir -p "$DESTINATION_DIR"
    ${pkgs.grim}/bin/grim "$DESTINATION_DIR/$(${pkgs.coreutils-full}/bin/date +%Y-%m-%d_%H:%M:%S_%s)_$(hostname)_nixos_autoscreen.png"
  '';
in
{
  home.packages = [ autoscreen ];

  systemd.user.timers."autoscreen" = {
    Unit = {
      Description = "Run autoscreen every hour at random";
      After = [ "multi-user.target" ];
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
