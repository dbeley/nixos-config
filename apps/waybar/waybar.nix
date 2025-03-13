{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
    };
    settings = [
      {
        layer = "top";
        modules-left = [
          "hyprland/workspaces"
          "niri/workspaces"
          "hyprland/window"
          "niri/window"
          # "mpd"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "network"
          "cpu"
          "memory"
          "temperature"
          "pulseaudio"
          "battery"
          "tray"
        ];
        "hyprland/window" = {
          "format" = "{}";
          "separate-outputs" = true;
        };
        "hyprland/workspaces" = {
          "active-only" = false;
          "all-outputs" = true;
          "show-special" = false;
          "on-click" = "activate";
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
        };
        "niri/workspaces" = {
          "all-outputs" = false;
        };
        mpd = {
          "max-length" = 30;
          "format" = "<span foreground='#1da0c3'></span>  {artist} - {title}";
          "format-paused" = "  {artist} - {title}";
          "format-stopped" = "";
          "format-disconnected" = "";
          "on-click" = "mpc --quiet toggle";
          "on-click-right" = "mpc ls | mpc add";
          "on-scroll-up" = "mpc --quiet prev";
          "on-scroll-down" = "mpc --quiet next";
          "smooth-scrolling-threshold" = 5;
          "tooltip" = false;
        };
        wireplumber = {
          "tooltip" = false;
          "format" = "VOL {volume}%";
          "format-muted" = "VOL mute";
        };
        pulseaudio = {
          "tooltip" = false;
          "scroll-step" = 5;
          "on-click" = "";
          "format" = "VOL {volume}%";
          "format-muted" = "VOL mute";
        };
        battery = {
          "format" = "BAT {capacity}%  ";
          "on-click" = "";
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "tooltip-format" = "{timeTo} ({power}W, {health}%)";
        };
        clock = {
          "interval" = 1;
          "format" = "{:%a %d %b %H:%M:%S}";
          "format-alt" = "{:%H:%M}";
          "locale" = "fr_FR.UTF-8";
          "timezone" = "Europe/Paris";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "format" = {
              "months" = "<span color='#ffead3'><b>{}</b></span>";
              "days" = "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
              "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
              "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          "actions" = {
            "on-click-right" = "mode";
            "on-click-forward" = "tz_up";
            "on-click-backward" = "tz_down";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };
        cpu = {
          "format" = "CPU {usage}%";
          "on-click" = "";
          "tooltip" = false;
        };
        memory = {
          "on-click" = "";
          "format" = "RAM {}%";
        };
        temperature = {
          "on-click" = "";
          "format" = " {temperatureC}°C";
        };
        network = {
          "tooltip" = true;
          "interval" = 5;
          "format" = "DOWN {bandwidthDownOctets} | UP {bandwidthUpOctets}";
          "on-click" = "";
          "tooltip-format" = "{ifname} via {gwaddr}";
        };
        tray = {
          "icon-size" = 21;
          "spacing" = 10;
        };
      }
    ];
    style = builtins.readFile ./waybar.css;
  };
}
