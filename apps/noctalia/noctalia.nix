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
        "bar.default" = {
          background_opacity = 0.5;
          end = [
            "tray"
            "notifications"
            "volume"
            "brightness"
            "battery"
            "session"
          ];
          start = [ "workspaces" ];
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
          "idle.behavior.lock" = {
            action = "lock";
            enabled = true;
            timeout = 1800;
          };
          "idle.behavior.screen-off" = {
            action = "screen_off";
            enabled = true;
            timeout = 900;
          };
          "idle.behavior.suspend" = {
            action = "suspend";
            enabled = true;
            lock_before_suspend = true;
            timeout = 1800;
          };
        };
        weather = {
          address = "Paris, France";
          auto_locate = true;
        };
        "widget.clock" = {
          format = "{:%a %d %b %H:%M}";
        };
        "widget.battery" = {
          display_mode = "graphic";
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
