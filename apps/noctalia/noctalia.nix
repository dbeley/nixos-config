{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];

  home.file.".config/noctalia/wallpapers/stylix-wallpaper" = {
    source = config.stylix.image;
  };

  programs = {
    noctalia = {
      enable = true;
      settings = {
        theme = {
          mode = "dark";
          source = "wallpaper";
        };
        wallpaper = {
          enabled = true;
          default.path = "${config.home.homeDirectory}/.config/noctalia/wallpapers/stylix-wallpaper";
        };
        shell = {
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
            # "network_rx"
            # "network_tx"
            # "notifications"
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
          start_time = "20:30";
          stop_time = "08:00";
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
        weather = {
          address = "Paris, France";
          auto_locate = true;
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
            display = "text";
          };
          network_rx = {
            display = "text";
          };
          network_tx = {
            display = "text";
          };
          ram = {
            display = "text";
          };
          sysmon = {
            display = "text";
          };
          temp = {
            display = "text";
          };
        };
      };
    };
  };

  wayland.windowManager.niri.settings = lib.mkIf config.wayland.windowManager.niri.enable {
    spawn-at-startup = [
      [ "noctalia" ]
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
        "volume"
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
