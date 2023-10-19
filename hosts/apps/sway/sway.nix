{
  pkgs,
  config,
  lib,
  user,
  ...
}: {
  home.packages = with pkgs; [mako libnotify grim slurp pamixer swaylock];
  home.file = {
    "scripts".source = pkgs.fetchFromGitHub {
      owner = "dbeley";
      repo = "scripts";
      rev = "705634a4832ac15df0df0319ce6048621afd6cc2";
      sha256 = "KWouJA2I0gVDjNwASI7sz3XrfyGQPwe6oqZ7mjjIw78=";
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;
    config = rec {
      terminal = "alacritty";
      modifier = "Mod4";
      fonts = {
        names = ["Iosevka Nerd Font"];
        style = "Regular";
        size = 10.0;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "intl";
          xkb_options = "ctrl:nocaps,shit:both_capslock";
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
      output = {"*" = {bg = "/home/${user}/.config/wpg/.current fill";};};
      seat = {"*" = {hide_cursor = "3000";};};

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

      keybindings = let
        modifiers = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          "${modifier}+d" = "exec ${pkgs.tofi}/bin/tofi-run -c ~/.cache/wal/tofi | xargs swaymsg exec --";
          "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+q" = "kill";
          "${modifier}+z" = "exec ${pkgs.firefox}/bin/firefox";
          "${modifier}+Shift+z" = "exec ${pkgs.emacs}/bin/emacs";
          "${modifier}+x" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+Shift+x" = "exec ${pkgs.steam}/bin/steam";
          "${modifier}+t" = "exec ${pkgs.libreoffice}/bin/soffice";
          "${modifier}+Shift+t" = "exec ${pkgs.gnome.gnome-system-monitor}/bin/gnome-system-monitor";
          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";
          "${modifier}+F9" = "scratchpad show";
          "${modifier}+F10" = "[app_id=\"org.keepassxc.KeePassXC\"] scratchpad show";
          "${modifier}+F11" = "[app_id=\"com.nextcloud.desktopclient.nextcloud\"] scratchpad show";
          "${modifier}+g" = "[app_id=\"scratchpad\"] scratchpad show";
          "${modifier}+c" = "[app_id=\"org.keepassxc.KeePassXC\"] scratchpad show";

          "XF86AudioRaiseVolume" = "exec ~/scripts/volume_pamixer.sh up";
          "Shift+XF86AudioRaiseVolume" = "exec ~/scripts/volume_pamixer.sh bigup";
          "XF86AudioLowerVolume" = "exec ~/scripts/volume_pamixer.sh down";
          "Shift+XF86AudioLowerVolume" = "exec ~/scripts/volume_pamixer.sh bigdown";
          "XF86AudioMute" = "exec ~/scripts/volume_pamixer.sh mute";
          "XF86MonBrightnessUp" = "exec light -A 5%";
          "XF86MonBrightnessDown" = "exec light -U 5%";
          "XF86Screensaver" = "exec swaylock -f -c 000000";
          "XF86Suspend" = "exec swaylock -f -c 000000";
          "XF86Back" = "workspace prev";
          "XF86Forward" = "workspace next";
          "XF86Display" = "exec ~/scripts/toggle_gammastep.sh";
          "Pause" = "exec killall -SIGUSR1 waybar";
          "Shift+Pause" = "exec wpg -m";

          "${modifier}+r" = "mode \"  resize  \"";
          "${modifier}+Shift+p" = "mode \"  (r)eboot, (p)oweroff, (l)ock, (s)uspend  \"";
          "${modifier}+Shift+s" = "sticky toggle";
        };
      bars = [
        {command = "waybar";}
      ];
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
            criteria = {app_id = "mpv";};
          }
          {
            command = "move to scratchpad";
            criteria = {app_id = "org.keepassxc.KeePassXC";};
          }
          {
            command = "move to scratchpad, scratchpad show";
            criteria = {app_id = "com.nextcloud.desktopclient.nextcloud";};
          }
          {
            command = "move to scratchpad, resize set 800 600";
            criteria = {app_id = "scratchpad";};
          }
        ];
      };
      floating = {
        criteria = [
          {title = "Ouvrir*";}
          {title = "Extension : *";}
          {app_id = "swayimg";}
          {app_id = "mpv";}
          {app_id = "org.keepassxc.KeePassXC";}
          {app_id = "com.nextcloud.desktopclient.nextcloud";}
        ];
        titlebar = false;
      };

      colors = {
        focused = {
          border = "$background";
          background = "$background";
          text = "$tx";
          indicator = "$color3";
          childBorder = "$color3";
        };
        unfocused = {
          border = "$color4";
          background = "$color4";
          text = "$tx";
          indicator = "$color1";
          childBorder = "$color1";
        };
        focusedInactive = {
          border = "$color4";
          background = "$color4";
          text = "$tx";
          indicator = "$color1";
          childBorder = "$color1";
        };
        urgent = {
          border = "$tx";
          background = "$tx";
          text = "$tx";
          indicator = "$tx";
          childBorder = "$tx";
        };
        placeholder = {
          border = "$tx";
          background = "$tx";
          text = "$tx";
          indicator = "$tx";
          childBorder = "$tx";
        };
      };

      startup = [
        {command = "systemctl --user import-environment; systemctl --user start sway-session.target";}
        {command = "mako -c /home/${user}/.cache/wal/mako";}
        {command = "udiskie -a";}
        {command = "nextcloud --background";}
        {command = "keepassxc";}
        {command = "${pkgs.alacritty}/bin/alacritty --class scratchpad -e ${pkgs.lf}";}
      ];
    };

    extraConfigEarly = ''
      include "/home/${user}/.cache/wal/colors-sway"
      set $tx #ffffff

      bindsym --release Print exec "grim ~/Nextcloud/10-19_Images/11_Images/11.07_Captures-d-écran_Sway/$(date +%s).png"
      bindsym --release Shift+Print exec 'grim -g "$(slurp -d)" ~/Nextcloud/10-19_Images/11_Images/11.07_Captures-d-écran_Sway/$(date +%s)_cropped.png'
      bindsym --release XF86SelectiveScreenshot exec 'grim -g "$(slurp -d)" ~/Nextcloud/10-19_Images/11_Images/11.07_Captures-d-écran_Sway/$(date +%s)_cropped.png'
    '';
  };
}
