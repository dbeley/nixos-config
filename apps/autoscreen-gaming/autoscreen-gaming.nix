{ pkgs, ... }:
let
  autoscreen_gaming = pkgs.writeShellScriptBin "autoscreen_gaming" ''
    active_window_info="$(hyprctl activewindow)"
    window_class="$(echo "$active_window_info" | grep -oP '(?<=class: ).*')"

    if [[ "$window_class" == "gamescope" || "$window_class" == steam_app_* ]]; then
        TODAY="$(${pkgs.coreutils-full}/bin/date +%Y-%m-%d)"
        DESTINATION_DIR="$HOME/Nextcloud/10-19_Images/11_Captures-d-écran/11.01_autoscreen/$TODAY"
        ${pkgs.coreutils-full}/bin/mkdir -p "$DESTINATION_DIR"
        ${pkgs.grim}/bin/grim "$DESTINATION_DIR/$(${pkgs.coreutils-full}/bin/date +%Y-%m-%d_%H:%M:%S_%s)_$(hostname)_nixos_autoscreen-gaming.png"
    fi
  '';
in
{
  home.packages = [ autoscreen_gaming ];

  systemd.user.timers."autoscreen_gaming" = {
    Unit = {
      Description = "Run autoscreen_gaming every 10 minutes at random";
      After = [ "multi-user.target" ];
    };
    Timer = {
      OnCalendar = "*:0/10";
      RandomizedDelaySec = 600;
      AccuracySec = "1us";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.services."autoscreen_gaming" = {
    Unit = {
      Description = "Take a screenshot with grim";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${autoscreen_gaming}/bin/autoscreen_gaming";
    };
    Install = {
      WantedBy = [ "multi-user.target" ];
    };
  };
}
