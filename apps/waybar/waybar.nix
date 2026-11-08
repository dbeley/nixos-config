{
  config,
  lib,
  pkgs,
  ...
}:
let
  helpers = import ../scripts/scripts.nix { inherit pkgs; };
  colors = config.lib.stylix.colors.withHashtag;
  style = pkgs.replaceVars ./waybar.css {
    inherit (colors)
      base00
      base01
      base03
      base05
      base0C
      ;
    font = config.stylix.fonts.monospace.name;
  };
in
{
  home.packages = with pkgs; [
    swaybg
    pamixer
    libnotify
  ];
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
    };
    settings = [
      {
        layer = "top";
        modules-left = [
          "niri/workspaces"
          "niri/window"
          # "mpd"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          # "network"
          # "cpu"
          # "memory"
          "temperature"
          "wireplumber"
          "battery"
          "tray"
        ];
        "niri/workspaces" = {
          "all-outputs" = false;
        };
        mpd = {
          "max-length" = 30;
          "format" = "<span foreground='${colors.base0C}'></span>  {artist} - {title}";
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
          "scroll-step" = 5;
          "format" = "VOL {volume}%";
          "format-muted" = "VOL mute";
        };
        battery = {
          "format" = "BAT {capacity}%";
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "tooltip-format" = "{timeTo} ({power}W, {health}%)";
        };
        clock = {
          "interval" = 60;
          "format" = "{:%H:%M}";
          "format-alt" = "{:L%a %d %b %H:%M}";
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
              "weeks" = "<span color='#99ffdd'><b>S{}</b></span>";
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
          "tooltip" = false;
        };
        memory = {
          "format" = "RAM {}%";
        };
        temperature = {
          "format" = " {temperatureC}°C";
        };
        network = {
          "tooltip" = true;
          "interval" = 5;
          "format" = "DOWN {bandwidthDownOctets} | UP {bandwidthUpOctets}";
          "tooltip-format" = "{ifname} via {gwaddr}";
        };
        tray = {
          "icon-size" = 21;
          "spacing" = 10;
        };
      }
    ];
    inherit style;
  };
  wayland.windowManager.niri.settings = lib.mkIf (config.wayland.windowManager.niri.enable or false) {
    _children = [
      {
        spawn-at-startup = [
          "swaybg"
          "-m"
          "fill"
          "-i"
          "${config.stylix.image}"
        ];
      }
    ];
    binds = {
      "XF86AudioRaiseVolume".spawn = [
        "${helpers.volumePamixer}"
        "up"
      ];
      "XF86AudioLowerVolume".spawn = [
        "${helpers.volumePamixer}"
        "down"
      ];
      "XF86AudioMute".spawn = [
        "${helpers.volumePamixer}"
        "mute"
      ];
      "Shift+XF86AudioRaiseVolume".spawn = [
        "${helpers.volumePamixer}"
        "bigup"
      ];
      "Shift+XF86AudioLowerVolume".spawn = [
        "${helpers.volumePamixer}"
        "bigdown"
      ];
      "XF86MonBrightnessDown".spawn = [
        "${helpers.brightness}"
        "1%-"
      ];
      "XF86MonBrightnessUp".spawn = [
        "${helpers.brightness}"
        "+1%"
      ];
      "Shift+XF86MonBrightnessDown".spawn = [
        "${helpers.brightness}"
        "10%-"
      ];
      "Shift+XF86MonBrightnessUp".spawn = [
        "${helpers.brightness}"
        "+10%"
      ];
      "XF86Display".spawn = [
        "${helpers.toggleGammastep}"
      ];
    };
  };
}
