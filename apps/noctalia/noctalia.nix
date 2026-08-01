{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs = {
    noctalia = {
      enable = true;
      settings = {
        theme = {
          mode = "dark";
        };
        wallpaper = {
          enabled = true;
          default.path = "${config.stylix.image}";
        };
        shell = {
          clipboard_enabled = false;
          telemetry_enabled = false;
        };
        bar.default = {
          background_opacity = 0.5;
          margin_ends = 80.0;
          end = [
            "tray"
            "cpu"
            "temp"
            "ram"
            "volume"
            "brightness"
            "battery"
          ];
          start = [
            "workspaces"
            "active_window"
          ];
        };
        nightlight = {
          enabled = true;
          temperature_day = 6500;
          temperature_night = 4000;
        };
        notification = {
          background_opacity = 0.5;
        };
        idle = {
          behavior_order = [
            "lock"
            "screen-off"
            "suspend"
          ];
          pre_action_fade_seconds = 0.0;
          behavior = {
            lock = {
              action = "lock";
              enabled = true;
              timeout = 1800;
            };
            screen-off = {
              action = "screen_off";
              enabled = true;
              timeout = 900;
            };
            suspend = {
              action = "suspend";
              enabled = true;
              lock_before_suspend = true;
              timeout = 1800;
            };
          };
        };
        location = {
          auto_locate = true;
          address = "Paris, France";
          custom_schedule = true;
          sunset = "20:30";
          sunrise = "08:00";
        };
        widget = {
          active_window = {
            title_scroll = "on_hover";
            max_length = 400.0;
          };
          battery = {
            display_mode = "graphic";
            show_label = true;
          };
          clock = {
            format = "{:%a %d %b %H:%M}";
          };
          cpu = {
            type = "sysmon";
            stat = "cpu_usage";
            visualization = "none";
            show_value = true;
          };
          ram = {
            type = "sysmon";
            stat = "ram_pct";
            visualization = "none";
            show_value = true;
          };
          temp = {
            type = "sysmon";
            stat = "cpu_temp";
            visualization = "none";
            show_value = true;
          };
        };
      };
    };
  };

  wayland.windowManager.niri.settings = lib.mkIf (config.wayland.windowManager.niri.enable or false) {
    _children = [
      { spawn-at-startup = [ "noctalia" ]; }
    ];
    binds = {
      "Mod+Shift+C"."spawn" = [
        "noctalia"
        "msg"
        "screen-lock"
      ];
      "Mod+Space"."spawn" = [
        "noctalia"
        "msg"
        "panel-toggle"
        "launcher"
      ];
      "Mod+Shift+P"."spawn" = lib.mkForce [
        "noctalia"
        "msg"
        "panel-toggle"
        "session"
      ];
      "XF86AudioRaiseVolume"."spawn" = [
        "noctalia"
        "msg"
        "volume-up"
      ];
      "XF86AudioLowerVolume"."spawn" = [
        "noctalia"
        "msg"
        "volume-down"
      ];
      "XF86AudioMute"."spawn" = [
        "noctalia"
        "msg"
        "volume-mute"
      ];
      "XF86MonBrightnessUp"."spawn" = [
        "noctalia"
        "msg"
        "brightness-up"
      ];
      "XF86MonBrightnessDown"."spawn" = [
        "noctalia"
        "msg"
        "brightness-down"
      ];
    };
  };
}
