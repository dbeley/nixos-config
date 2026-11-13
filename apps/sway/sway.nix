{
  pkgs,
  config,
  lib,
  ...
}:
let
  helpers = import ../scripts/scripts.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    libnotify
    grim
    slurp
    pamixer
  ];
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;
    config = {
      terminal = "foot";
      modifier = "Mod4";
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "intl";
          xkb_options = "ctrl:nocaps,shift:both_capslock,lv3:menu_switch";
          repeat_delay = "200";
          repeat_rate = "60";
        };
        "type:pointer" = {
          left_handed = "enabled";
        };
        "type:touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
        };
      };
      seat = {
        "*" = {
          hide_cursor = "3000";
        };
      };

      output = {
        "AU Optronics 0x116D Unknown" = {
          position = "0 0";
          scale = "2";
        };
        "LG Display 0x067C Unknown" = {
          scale = "2";
        };
        "Samsung Electric Company Q90A 0x01000E00" = {
          mode = "3840x2160@60Hz";
          scale = "2";
        };
        "Dell Inc. DELL S2721DGF 6C1TR83" = {
          mode = "2560x1440@143.912Hz";
          position = "0 0";
        };
        "LG Display 0x05EF Unknown" = {
          mode = "2560x1440@59.998Hz";
          scale = "1.6";
        };
        "LG Electronics LG IPS FULLHD 0x01010101" = {
          position = "0 0";
        };
        "eDP-1" = {
          scale = "1.25";
        };
      };

      modes = {
        "  resize  " = {
          Down = "resize grow height 10 px";
          Escape = "mode default";
          Left = "resize shrink width 10 px";
          Return = "mode default";
          Right = "resize grow width 10 px";
          Up = "resize shrink height 10 px";
          h = "resize shrink width 10 px";
          j = "resize grow height 10 px";
          k = "resize shrink height 10 px";
          l = "resize grow width 10 px";
        };
        "  (r)eboot, (p)oweroff, (l)ock, (s)uspend  " = {
          r = "exec reboot, mode default";
          p = "exec poweroff, mode default";
          l = "exec swaylock -f -c 000000, mode default";
          s = "systemctl suspend; swaylock -f -c 000000, mode default";
        };
      };

      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+e" = "exec ${pkgs.tofi}/bin/tofi-run | xargs swaymsg exec --";
          "${mod}+Return" = "exec ${pkgs.foot}/bin/foot";
          "${mod}+q" = "kill";
          "${mod}+z" = "exec ${pkgs.firefox}/bin/firefox";
          "${mod}+x" = "exec ${pkgs.foot}/bin/foot";
          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";
          "${mod}+F9" = "scratchpad show";
          "${mod}+F10" = ''[app_id="org.keepassxc.KeePassXC"] scratchpad show'';
          "${mod}+F11" = ''[app_id="com.nextcloud.desktopclient.nextcloud"] scratchpad show'';
          "${mod}+g" = ''[app_id="scratchpad"] scratchpad show'';
          "${mod}+c" = ''[app_id="org.keepassxc.KeePassXC"] scratchpad show'';
          "${mod}+d" = ''[app_id="Supersonic"] scratchpad show'';

          "XF86AudioRaiseVolume" = "exec ${helpers.volumePamixer} up";
          "Shift+XF86AudioRaiseVolume" = "exec ${helpers.volumePamixer} bigup";
          "XF86AudioLowerVolume" = "exec ${helpers.volumePamixer} down";
          "Shift+XF86AudioLowerVolume" = "exec ${helpers.volumePamixer} bigdown";
          "XF86AudioMute" = "exec ${helpers.volumePamixer} mute";
          "XF86MonBrightnessUp" = "exec brightnessctl s +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl -s 5%-";
          "XF86Screensaver" = "exec swaylock -f -c 000000";
          "XF86Suspend" = "exec swaylock -f -c 000000";
          "XF86Back" = "workspace prev";
          "XF86Forward" = "workspace next";
          "XF86Display" = "exec ${helpers.toggleGammastep}";
          "Pause" = "exec killall -SIGUSR1 waybar";

          "${mod}+r" = ''mode "  resize  "'';
          "${mod}+Shift+p" = ''mode "  (r)eboot, (p)oweroff, (l)ock, (s)uspend  "'';
          "${mod}+Shift+s" = "sticky toggle";
        };
      bars = [ { command = "waybar-session"; } ];
      gaps = {
        inner = 6;
        outer = 6;
        smartBorders = "on";
      };

      window = {
        border = 3;
        titlebar = false;
        commands = [
          {
            command = "sticky enable";
            criteria = {
              app_id = "mpv";
            };
          }
          {
            command = "move to scratchpad";
            criteria = {
              app_id = "org.keepassxc.KeePassXC";
            };
          }
          {
            command = "move to scratchpad";
            criteria = {
              app_id = "Supersonic";
            };
          }
          {
            command = "move to scratchpad, scratchpad show";
            criteria = {
              app_id = "com.nextcloud.desktopclient.nextcloud";
            };
          }
          {
            command = "move to scratchpad, resize set 800 600";
            criteria = {
              app_id = "scratchpad";
            };
          }
          {
            command = "resize set 60ppt 120px, move position 20ppt 79.4ppt, opacity 0.7";
            criteria = {
              app_id = "one.alynx.showmethekey";
              title = "^Floating Window - Show Me The Key$";
            };
          }
        ];
      };
      floating = {
        criteria = [
          { title = "Ouvrir*"; }
          { title = "Extension : *"; }
          { app_id = "swayimg"; }
          { app_id = "mpv"; }
          { app_id = "org.keepassxc.KeePassXC"; }
          { app_id = "Supersonic"; }
          { app_id = "com.nextcloud.desktopclient.nextcloud"; }
          { app_id = "one.alynx.showmethekey"; }
        ];
        titlebar = false;
      };

      startup = [
        { command = "systemctl --user import-environment; systemctl --user start sway-session.target"; }
        { command = "mako"; }
        { command = "udiskie -a"; }
        { command = "keepassxc"; }
      ];
    };

    extraConfigEarly = ''
      set $tx #ffffff

      no_focus [app_id="one.alynx.showmethekey"]

      bindsym --release Print exec "grim ~/Nextcloud/30-39_Images/32_Captures-d-écran/32.17_Captures-d-écran_Sway/$(date +%s).png"
      bindsym --release Shift+Print exec 'grim -g "$(slurp -d)" ~/Nextcloud/30-39_Images/32_Captures-d-écran/32.17_Captures-d-écran_Sway/$(date +%s)_cropped.png'
      bindsym --release XF86SelectiveScreenshot exec 'grim -g "$(slurp -d)" ~/Nextcloud/30-39_Images/32_Captures-d-écran/32.17_Captures-d-écran_Sway/$(date +%s)_cropped.png'
    '';
  };
}
