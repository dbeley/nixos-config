{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "bottom";
      modules-left = ["wlr/workspaces" "sway/workspaces" "sway/mode" "sway/window" "hyprland/window"];
      modules-center = ["clock"];
      modules-right = ["network" "cpu" "memory" "temperature" "pulseaudio" "battery" "tray"];
      "sway/window" = {
      	"max-length" = 50;
      	"icon" = false;
      };
      "hyprland/window" = {
      	"format" = "{}";
      	"separate-outputs" = true;
      };
      "wlr/workspaces" = {
      	"active-only" = false;
      	"all-outputs" = true;
      	"format" = "{icon}";
      	"on-click" = "activate";
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
    }];
    style = builtins.readFile ./waybar.css;
  };
}
