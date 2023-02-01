{ pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [ pamixer swaylock ];
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;
    config = rec {
      terminal = "alacritty";
      modifier = "Mod4";
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
      seat = { "*" = { hide_cursor = "3000"; }; };

      modes = {
        "resize" = {
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
        "(r)eboot, (p)oweroff, (l)ock, (s)uspend" = {
          r = "exec reboot, mode default";
          p = "exec poweroff, mode default";
          l = "exec swaylock -f -c 000000, mode default";
          s = "systemctl suspend; swaylock -f -c 000000, mode default";
        };
      };

      keybindings = let
          modifiers = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+q" = "kill";
          "${modifier}+z" = "exec ${pkgs.firefox}/bin/firefox";
          "${modifier}+Shift+z" = "exec ${pkgs.emacs}/bin/emacs";
          "${modifier}+x" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+Shift+x" = "exec ${pkgs.steam}/bin/steam";
          "${modifier}+t" = "exec ${pkgs.libreoffice}/bin/libreoffice";
          "${modifier}+Shift+t" = "exec ${pkgs.gnome.gnome-system-monitor}/bin/gnome-system-monitor";

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

          "${modifier}+r" = "mode \"resize\"";
          "${modifier}+Shift+p" = "mode \"(r)eboot, (p)oweroff, (l)ock, (s)uspend\"";
        };

      startup = [
        { command = "mako"; }
        { command = "udiskie -a"; }
        { command = "nextcloud --background"; }
        # { command = "keepassxc"; }
      ];
    };
  };
}
