{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    libnotify
    grim
    slurp
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
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;
    config = {
      terminal = "kitty";
      modifier = "Mod4";
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "intl";
          xkb_options = "ctrl:nocaps,shift:both_capslock";
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
          "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
          "${mod}+q" = "kill";
          "${mod}+z" = "exec ${pkgs.firefox}/bin/firefox";
          "${mod}+Shift+z" = "exec ${pkgs.emacs}/bin/emacs";
          "${mod}+x" = "exec ${pkgs.kitty}/bin/kitty";
          "${mod}+Shift+x" = "exec ${pkgs.steam}/bin/steam";
          "${mod}+t" = "exec ${pkgs.libreoffice}/bin/soffice";
          "${mod}+Shift+t" = "exec ${pkgs.gnome-system-monitor}/bin/gnome-system-monitor";
          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";
          "${mod}+F9" = "scratchpad show";
          "${mod}+F10" = ''[app_id="org.keepassxc.KeePassXC"] scratchpad show'';
          "${mod}+F11" = ''[app_id="com.nextcloud.desktopclient.nextcloud"] scratchpad show'';
          "${mod}+g" = ''[app_id="scratchpad"] scratchpad show'';
          "${mod}+c" = ''[app_id="org.keepassxc.KeePassXC"] scratchpad show'';
          "${mod}+d" = ''[app_id="Supersonic"] scratchpad show'';

          "XF86AudioRaiseVolume" = "exec ~/scripts/volume_pamixer.sh up";
          "Shift+XF86AudioRaiseVolume" = "exec ~/scripts/volume_pamixer.sh bigup";
          "XF86AudioLowerVolume" = "exec ~/scripts/volume_pamixer.sh down";
          "Shift+XF86AudioLowerVolume" = "exec ~/scripts/volume_pamixer.sh bigdown";
          "XF86AudioMute" = "exec ~/scripts/volume_pamixer.sh mute";
          "XF86MonBrightnessUp" = "exec brightnessctl s +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl -s 5%-";
          "XF86Screensaver" = "exec swaylock -f -c 000000";
          "XF86Suspend" = "exec swaylock -f -c 000000";
          "XF86Back" = "workspace prev";
          "XF86Forward" = "workspace next";
          "XF86Display" = "exec ~/scripts/toggle_gammastep.sh";
          "Pause" = "exec killall -SIGUSR1 waybar";

          "${mod}+r" = ''mode "  resize  "'';
          "${mod}+Shift+p" = ''mode "  (r)eboot, (p)oweroff, (l)ock, (s)uspend  "'';
          "${mod}+Shift+s" = "sticky toggle";
        };
      bars = [ { command = "waybar"; } ];
      gaps = {
        inner = 6;
        outer = 6;
        smartBorders = "on";
      };

      window = {
        border = 3;
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
        ];
        titlebar = false;
      };

      startup = [
        { command = "systemctl --user import-environment; systemctl --user start sway-session.target"; }
        { command = "mako"; }
        { command = "udiskie -a"; }
        { command = "nextcloud --background"; }
        { command = "keepassxc"; }
        { command = "${pkgs.kitty}/bin/kitty --class=scratchpad -e ${pkgs.lf}"; }
      ];
    };

    extraConfigEarly = ''
      set $tx #ffffff

      bindsym --release Print exec "grim ~/Nextcloud/10-19_Images/11_Captures-d-écran/11.07_Captures-d-écran_Sway/$(date +%s).png"
      bindsym --release Shift+Print exec 'grim -g "$(slurp -d)" ~/Nextcloud/10-19_Images/11_Captures-d-écran/11.07_Captures-d-écran_Sway/$(date +%s)_cropped.png'
      bindsym --release XF86SelectiveScreenshot exec 'grim -g "$(slurp -d)" ~/Nextcloud/10-19_Images/11_Captures-d-écran/11.07_Captures-d-écran_Sway/$(date +%s)_cropped.png'
    '';
  };
}
