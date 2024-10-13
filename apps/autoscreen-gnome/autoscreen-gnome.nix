{ pkgs, ... }:
let
  autoscreen_gnome = pkgs.writeShellScriptBin "autoscreen_gnome" ''
    TODAY="$(${pkgs.coreutils-full}/bin/date +%Y-%m-%d)"
    DESTINATION_DIR="$HOME/Nextcloud/10-19_Images/11_Captures-d-écran/11.01_autoscreen/$TODAY"

    ${pkgs.coreutils-full}/bin/mkdir -p "$DESTINATION_DIR"
    ${pkgs.flameshot}/bin/flameshot full -p "$DESTINATION_DIR/$(${pkgs.coreutils-full}/bin/date +%Y-%m-%d_%H:%M:%S_%s)_$(hostname)_nixos_autoscreen.png"
  '';
in
{
  home.packages = [ autoscreen_gnome ];

  systemd.user.timers."autoscreen_gnome" = {
    Unit = {
      Description = "Run autoscreen every hour at random (gnome-compatible)";
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

  systemd.user.services."autoscreen_gnome" = {
    Unit = {
      Description = "Take a screenshot with flameshot";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${autoscreen_gnome}/bin/autoscreen_gnome";
    };
    Install = {
      WantedBy = [ "multi-user.target" ];
    };
  };
}
