{
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "bottom";
        modules-left = ["wlr/workspaces" "hyprland/window" "mpd"];
        modules-center = ["clock"];
        modules-right = ["network" "cpu" "memory" "temperature" "pulseaudio" "battery" "tray"];
        "hyprland/window" = {
          "format" = "{}";
          "separate-outputs" = true;
        };
        "wlr/workspaces" = {
          "active-only" = false;
          "all-outputs" = true;
          "format" = "{icon}";
          "on-click" = "activate";
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
        };
        mpd = {
          "max-length" = 30;
          "format" = "<span foreground='#1da0c3'></span>  {artist} - {title}";
          "format-paused" = "  {artist} - {title}";
          "format-stopped" = "";
          "format-disconnected" = "";
          "on-click" = "mpc --quiet toggle";
          "on-click-right" = "mpc ls | mpc add";
          "on-click-middle" = "alacritty --class='ncmpcpp' ncmpcpp ";
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
        };
        clock = {
          "interval" = 1;
          "format" = "{:%a %d %b %H:%M:%S}";
          "format-alt" = "{:%H:%M}";
          "locale" = "fr_FR.UTF-8";
          "timezone" = "Europe/Paris";
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
          "tooltip-format" = "{ifname} via {gwaddr} ";
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
