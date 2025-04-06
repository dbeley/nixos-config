{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    xwayland-satellite
    swaybg
    libnotify
    pamixer
  ];
  home.file = {
    "scripts".source = pkgs.fetchFromGitHub {
      owner = "dbeley";
      repo = "scripts";
      rev = "a8607fbfb8c50543629e14ec483473459229091d";
      sha256 = "XBumWlu4+z/jTKLK71Lr0hMeLhc43XD3oEzY+YUMzN4=";
    };
  };
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      environment = {
        "NIXOS_OZONE_WL" = "1";
        "DISPLAY" = ":0";
      };
      input = {
        keyboard = {
          repeat-delay = 200;
          repeat-rate = 60;
          xkb = {
            layout = "us";
            options = "ctrl:nocaps,shift:both_capslock";
            variant = "intl";
          };
        };
        mouse = {
          left-handed = true;
        };
        touchpad = {
          left-handed = true;
          tap = true;
          dwt = true;
          natural-scroll = true;
          click-method = "clickfinger";
        };
        trackpoint = {
          left-handed = true;
        };
        trackball = {
          left-handed = true;
        };
        focus-follows-mouse = {
          enable = true;
        };
      };
      outputs = {
        # niri msg outputs
        eDP-1 = {
          scale = 1.25;
          variable-refresh-rate = true;
        };
        "LG Display 0x067C Unknown" = {
          scale = 2;
          variable-refresh-rate = true;
        };
        "Samsung Electric Company Q90A 0x01000E00" = {
          scale = 2;
          mode = {
            height = 2160;
            width = 3840;
            refresh = 60.0;
          };
        };
      };
      cursor = {
        hide-after-inactive-ms = 5000;
      };
      layout = {
        gaps = 16;
        preset-column-widths = [
          { proportion = 1. / 4.; }
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];
        preset-window-heights = [
          { proportion = 1. / 4.; }
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];
      };
      screenshot-path = "~/Nextcloud/10-19_Images/11_Captures-d-écran/11.09_Captures-d-écran_Niri/%Y-%d-%d %H-%M-%S.png";
      spawn-at-startup = [
        {
          command = [
            "systemctl"
            "--user"
            "reset-failed"
            "waybar-service"
          ];
        }
        {
          command = [ "mako" ];
        }
        {
          command = [ "xwayland-satellite" ];
        }
        {
          command = [
            "swaybg"
            "-m"
            "fill"
            "-i"
            "${config.stylix.image}"
          ];
        }
      ];
      window-rules = [
        {
          matches = [ { is-focused = false; } ];
          opacity = 0.95;
        }
        {
          matches = [
            {
              app-id = "firefox";
              title = "Picture-in-Picture";
            }
            { app-id = "mpv"; }
            {
              app-id = "steam";
              title = "Friends List";
            }
            {
              app-id = "steam";
              title = "Steam Settings";
            }
            {
              app-id = "jetbrains.*";
              title = "Open File or Project";
            }
            {
              app-id = "jetbrains.*";
              title = "Settings";
            }
            {
              app-id = "jetbrains.*";
              title = "Confirm Exit";
            }
            {
              app-id = "jetbrains.*";
              title = "Update Project";
            }
            {
              app-id = "zoom";
              title = "Zoom Workplace";
            }
            {
              app-id = "zoom";
              title = "Settings";
            }
            {
              app-id = "zoom";
              title = "zoom";
            }
            {
              app-id = "swayimg";
            }
            {
              title = "Ouvrir.*";
            }
            {
              title = "Extension.*";
            }
            {
              title = "Enregistrer.*";
            }
            {
              title = "Add.*";
            }
          ];
          open-floating = true;
        }
        {
          matches = [
            { app-id = "org.keepassxc.KeePassXC"; }
          ];
          block-out-from = "screen-capture";
        }
        {
          matches = [ ];
          geometry-corner-radius = {
            bottom-left = 12.0;
            bottom-right = 12.0;
            top-left = 12.0;
            top-right = 12.0;
          };
          clip-to-geometry = true;
        }
      ];
      hotkey-overlay = {
        skip-at-startup = true;
      };
      binds = with config.lib.niri.actions; {
        "Mod+Shift+Slash".action = show-hotkey-overlay;
        "XF86AudioRaiseVolume".action.spawn = [
          "~/scripts/volume_pamixer.sh"
          "up"
        ];
        "XF86AudioLowerVolume".action.spawn = [
          "~/scripts/volume_pamixer.sh"
          "down"
        ];
        "XF86AudioMute".action.spawn = [
          "~/scripts/volume_pamixer.sh"
          "mute"
        ];
        "Shift+XF86AudioRaiseVolume".action.spawn = [
          "~/scripts/volume_pamixer.sh"
          "bigup"
        ];
        "Shift+XF86AudioLowerVolume".action.spawn = [
          "~/scripts/volume_pamixer.sh"
          "bigdown"
        ];
        "XF86MonBrightnessDown".action.spawn = [
          "brightnessctl"
          "s"
          "5%-"
        ];
        "XF86MonBrightnessUp".action.spawn = [
          "brightnessctl"
          "s"
          "+5%"
        ];
        "XF86Display".action.spawn = [
          "~/scripts/toggle_gammastep.sh"
        ];
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;
        "Mod+Shift+E".action = quit;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Q".action = close-window;
        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;
        "Mod+L".action = focus-column-right;
        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-or-workspace-down;
        "Mod+Up".action = focus-window-or-workspace-up;
        "Mod+Right".action = focus-column-right;
        "Mod+Ctrl+H".action = focus-monitor-left;
        "Mod+Ctrl+J".action = focus-monitor-down;
        "Mod+Ctrl+K".action = focus-monitor-up;
        "Mod+Ctrl+L".action = focus-monitor-right;
        "Mod+Ctrl+Left".action = focus-monitor-left;
        "Mod+Ctrl+Down".action = focus-monitor-down;
        "Mod+Ctrl+Up".action = focus-monitor-up;
        "Mod+Ctrl+Right".action = focus-monitor-right;
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Down".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+Up".action = move-window-up-or-to-workspace-up;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Ctrl+Shift+H".action = move-column-to-monitor-left;
        "Mod+Ctrl+Shift+J".action = move-column-to-monitor-down;
        "Mod+Ctrl+Shift+K".action = move-column-to-monitor-up;
        "Mod+Ctrl+Shift+L".action = move-column-to-monitor-right;
        "Mod+Ctrl+Shift+Left".action = move-column-to-monitor-left;
        "Mod+Ctrl+Shift+Down".action = move-column-to-monitor-down;
        "Mod+Ctrl+Shift+Up".action = move-column-to-monitor-up;
        "Mod+Ctrl+Shift+Right".action = move-column-to-monitor-right;
        "Mod+WheelScrollUp".action = focus-column-left;
        "Mod+WheelScrollDown".action = focus-column-right;
        "Mod+Shift+WheelScrollUp".action = focus-window-or-workspace-up;
        "Mod+Shift+WheelScrollDown".action = focus-window-or-workspace-down;
        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Shift+U".action = move-column-to-workspace-down;
        "Mod+Shift+I".action = move-column-to-workspace-up;
        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
        "Mod+W".action = toggle-column-tabbed-display;
        "Mod+C".action = center-column;
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = switch-preset-window-height;
        "Mod+Ctrl+R".action = reset-window-height;
        "Mod+Shift+Ctrl+R".action = reset-window-height;
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Shift+Print".action.screenshot = { };
        "Print".action.screenshot-screen = { };
        "Mod+E".action.spawn = [
          "bash"
          "-c"
          "tofi-run | xargs niri msg action spawn --"
        ];
        "Mod+Z".action.spawn = "firefox";
        "Mod+D".action.spawn = "supersonic";
        "Mod+N".action.spawn = "keepassxc";
        "Mod+T".action.spawn = "soffice";
        "Mod+Shift+T".action.spawn = "gnome-system-monitor";
        "Mod+Shift+C".action.spawn = [
          "hyprlock"
        ];
        "Mod+Return".action.spawn = "ghostty";
        "Mod+X".action.spawn = "ghostty";
        "Mod+Shift+P".action.spawn = "poweroff";
        "Mod+Shift+O".action.spawn = "reboot";
      };
    };
  };
}
