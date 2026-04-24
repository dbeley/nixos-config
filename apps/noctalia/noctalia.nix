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
    noctalia-shell = {
      enable = true;
      settings = {
        settingsVersion = 59;
        bar = {
          position = "top";
          density = "spacious";
          showCapsule = false;
          backgroundOpacity = lib.mkForce 0.0;
          useSeparateOpacity = true;
          widgets = {
            left = [
              {
                id = "Workspace";
                hideUnoccupied = false;
                labelMode = "index";
                pillSize = 0.7;
              }
              {
                id = "ActiveWindow";
                maxWidth = 400;
              }
            ];
            center = [
              {
                id = "Clock";
                formatHorizontal = "ddd dd MMM HH:mm:ss";
                tooltipFormat = "HH:mm, ddd dd MMM YYYY";
              }
            ];
            right = [
              {
                id = "SystemMonitor";
                compactMode = false;
                showCpuTemp = true;
                showCpuUsage = true;
                showMemoryAsPercent = true;
                showMemoryUsage = true;
                showNetworkStats = true;
              }
              { id = "Tray"; }
              {
                id = "Volume";
                displayMode = "alwaysShow";
              }
              {
                id = "Brightness";
                displayMode = "alwaysShow";
              }
              {
                id = "Battery";
                displayMode = "graphic";
              }
              {
                id = "ControlCenter";
                icon = "currency";
              }
            ];
          };
        };
        general = {
          dimmerOpacity = 0.0;
          radiusRatio = 0.2;
          enableBlurBehind = false;
          lockOnSuspend = true;
          lockScreenAnimations = true;
          lockScreenBlur = 0.6;
          enableLockScreenCountdown = false;
          compactLockScreen = true;
          showSessionButtonsOnLockScreen = false;
        };
        appLauncher = {
          terminalCommand = "ghostty -e";
        };
        idle = {
          enabled = true;
          lockTimeout = 1800;
          screenOffTimeout = 900;
          suspendTimeout = 1800;
        };
        controlCenter = {
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = false;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };
        colorSchemes = {
          predefinedScheme = "Monochrome";
          darkMode = true;
        };
        location = {
          name = "Paris, France";
          monthBeforeDay = true;
        };
        nightLight = {
          enabled = true;
          autoSchedule = true;
          dayTemp = "6500";
          nightTemp = "4000";
        };
        notifications = {
          enabled = true;
          location = "top_right";
        };
        dock = {
          enabled = false;
        };
        wallpaper = {
          enabled = true;
          directory = "${config.home.homeDirectory}/.config/noctalia/wallpapers";
        };
      };
    };

    niri.settings = lib.mkIf config.programs.niri.enable {
      spawn-at-startup = [
        { command = [ "noctalia-shell" ]; }
      ];
      binds = {
        "Mod+Shift+C".action = lib.mkForce {
          spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "lockScreen"
            "lock"
          ];
        };
        "Mod+Space".action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "launcher"
          "toggle"
        ];
        "Mod+Shift+P".action = lib.mkForce {
          spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "sessionMenu"
            "toggle"
          ];
        };
        "XF86AudioRaiseVolume".action = lib.mkForce {
          spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "volume"
            "increase"
          ];
        };
        "XF86AudioLowerVolume".action = lib.mkForce {
          spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "volume"
            "decrease"
          ];
        };
        "XF86AudioMute".action = lib.mkForce {
          spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "volume"
            "muteOutput"
          ];
        };
        "XF86MonBrightnessUp".action = lib.mkForce {
          spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "brightness"
            "increase"
          ];
        };
        "XF86MonBrightnessDown".action = lib.mkForce {
          spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "brightness"
            "decrease"
          ];
        };
      };
    };
  };
}
