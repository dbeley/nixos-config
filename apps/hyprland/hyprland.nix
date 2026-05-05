{
  pkgs,
  config,
  lib,
  ...
}:
let
  screenshot-dir = "~/Nextcloud/30-39_Images/32_Captures-d-écran/32.20_Captures-d-écran_Hyprland";
  screenshot-screen = pkgs.writeShellScriptBin "hyprland-screenshot-screen" ''
    ${pkgs.coreutils}/bin/mkdir -p ${screenshot-dir}
    ${pkgs.grim}/bin/grim -o "$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')" "${screenshot-dir}/$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S).png"
  '';
  screenshot-region = pkgs.writeShellScriptBin "hyprland-screenshot-region" ''
    ${pkgs.coreutils}/bin/mkdir -p ${screenshot-dir}
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "${screenshot-dir}/$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)_cropped.png"
  '';
  screenshot-window = pkgs.writeShellScriptBin "hyprland-screenshot-window" ''
    ${pkgs.coreutils}/bin/mkdir -p ${screenshot-dir}
    GEOM=$(${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    ${pkgs.grim}/bin/grim -g "$GEOM" "${screenshot-dir}/$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)_window.png"
  '';
in
{
  home.packages = [
    pkgs.wl-clipboard-rs
    screenshot-screen
    screenshot-region
    screenshot-window
    pkgs.grim
    pkgs.slurp
    pkgs.jq
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      env = [
        "NIXOS_OZONE_WL,1"
        "DISPLAY,:0"
        "GTK_IM_MODULE,simple"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "intl";
        kb_options = "ctrl:nocaps,shift:both_capslock,lv3:menu_switch";
        repeat_delay = 200;
        repeat_rate = 60;
        numlock_by_default = false;

        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
        };

        follow_mouse = 1;
      };

      monitor = [
        "LG Display 0x067C, preferred, auto, 2"
        "Samsung Electric Company Q90A 0x01000E00, 3840x2160@60, auto, 2"
        "Dell Inc. DELL S2721DGF 6C1TR83, 2560x1440@143.912, 0x0, 1"
        "LG Display 0x05EF, 2560x1440@59.998, auto, 1.6"
        "LG Electronics LG IPS FULLHD 0x01010101, preferred, 0x0, 1"
        "eDP-1, preferred, auto, 1.25"
      ];

      general = {
        gaps_in = 8;
        gaps_out = 16;
        border_size = 4;
        "col.active_border" = lib.mkForce config.lib.stylix.colors.withHashtag.base0D;
        "col.inactive_border" = lib.mkForce config.lib.stylix.colors.withHashtag.base03;
        layout = "dwindle";
        cursor_inactive_timeout = 5;
      };

      decoration = {
        rounding = 12;
        inactive_opacity = 0.90;
        blur = {
          enabled = true;
          size = 4;
          passes = 3;
          noise = 0.0;
          contrast = 1.0;
          brightness = 1.0;
          popups = true;
        };
      };

      exec-once = [
        "noctalia-shell"
      ];

      windowrulev2 = [
        # Floating windows
        "float, class:^(firefox)$, title:^(Picture-in-Picture)$"
        "float, class:^(mpv)$"
        "float, class:^(steam)$, title:^(Friends List)$"
        "float, class:^(steam)$, title:^(Steam Settings)$"
        "float, class:^(jetbrains-.*)$, title:^(Open File or Project)$"
        "float, class:^(jetbrains-.*)$, title:^(Settings)$"
        "float, class:^(jetbrains-.*)$, title:^(Confirm Exit)$"
        "float, class:^(jetbrains-.*)$, title:^(Update Project)$"
        "float, class:^(zoom)$, title:^(Zoom Workplace)$"
        "float, class:^(zoom)$, title:^(Settings)$"
        "float, class:^(zoom)$, title:^(zoom)$"
        "float, class:^(swayimg)$"
        "float, title:^(Ouvrir.*)$"
        "float, title:^(Extension.*)$"
        "float, title:^(Enregistrer.*)$"
        "float, title:^(Add.*)$"
        # Ghostty pickers
        "float, class:^(com.ghostty.mpd-picker)$"
        "size 40% 30%, class:^(com.ghostty.mpd-picker)$"
        "move 0 0, class:^(com.ghostty.mpd-picker)$"
        "float, class:^(com.ghostty.real-book-picker)$"
        "size 40% 30%, class:^(com.ghostty.real-book-picker)$"
        "move 0 0, class:^(com.ghostty.real-book-picker)$"
      ];

      layerrule = [
        "blur, noctalia-wallpaper*"
      ];

      bind = [
        # Hotkey overlay
        "SUPER SHIFT, Slash, exec, noctalia-shell ipc call hotkeyOverlay toggle"
        # Overview / workspace switcher
        ", XF86NotificationCenter, exec, noctalia-shell ipc call overview toggle"
        ", XF86PickupPhone, exec, noctalia-shell ipc call overview toggle"
        ", XF86HangupPhone, exec, noctalia-shell ipc call overview toggle"
        ", XF86Favorites, exec, noctalia-shell ipc call overview toggle"
        "SUPER, Tab, exec, noctalia-shell ipc call overview toggle"
        # Workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        # Session
        "SUPER SHIFT, E, exit,"
        "SUPER SHIFT, P, exec, noctalia-shell ipc call sessionMenu toggle"
        "SUPER SHIFT, O, exec, reboot"
        # Window management
        "SUPER, F, fullscreen, 1"
        "SUPER SHIFT, F, fullscreen, 0"
        "SUPER, Q, killactive,"
        "SUPER, V, togglefloating,"
        "SUPER, C, centerwindow,"
        "SUPER, Minus, resizeactive, -10% 0"
        "SUPER, Equal, resizeactive, 10% 0"
        "SUPER SHIFT, Minus, resizeactive, 0 -10%"
        "SUPER SHIFT, Equal, resizeactive, 0 10%"
        # Focus
        "SUPER, H, movefocus, l"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"
        "SUPER, L, movefocus, r"
        "SUPER, Left, movefocus, l"
        "SUPER, Down, movefocus, d"
        "SUPER, Up, movefocus, u"
        "SUPER, Right, movefocus, r"
        # Monitor focus
        "SUPER CTRL, H, focusmonitor, l"
        "SUPER CTRL, J, focusmonitor, d"
        "SUPER CTRL, K, focusmonitor, u"
        "SUPER CTRL, L, focusmonitor, r"
        "SUPER CTRL, Left, focusmonitor, l"
        "SUPER CTRL, Down, focusmonitor, d"
        "SUPER CTRL, Up, focusmonitor, u"
        "SUPER CTRL, Right, focusmonitor, r"
        # Move window
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, J, movewindow, d"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, Left, movewindow, l"
        "SUPER SHIFT, Down, movewindow, d"
        "SUPER SHIFT, Up, movewindow, u"
        "SUPER SHIFT, Right, movewindow, r"
        # Move window to monitor
        "SUPER CTRL SHIFT, H, movewindow, mon:l"
        "SUPER CTRL SHIFT, J, movewindow, mon:d"
        "SUPER CTRL SHIFT, K, movewindow, mon:u"
        "SUPER CTRL SHIFT, L, movewindow, mon:r"
        "SUPER CTRL SHIFT, Left, movewindow, mon:l"
        "SUPER CTRL SHIFT, Down, movewindow, mon:d"
        "SUPER CTRL SHIFT, Up, movewindow, mon:u"
        "SUPER CTRL SHIFT, Right, movewindow, mon:r"
        # Workspace navigation
        "SUPER, U, workspace, e+1"
        "SUPER, I, workspace, e-1"
        "SUPER SHIFT, U, movetoworkspace, e+1"
        "SUPER SHIFT, I, movetoworkspace, e-1"
        # Application binds
        "SUPER, Z, exec, zen-twilight"
        "SUPER, S, exec, steam"
        "SUPER, Y, exec, nextcloud"
        "SUPER, B, exec, chromium"
        "SUPER, T, exec, soffice"
        "SUPER, D, exec, feishin"
        "SUPER, N, exec, keepassxc"
        "SUPER SHIFT, T, exec, gnome-system-monitor"
        "SUPER, Return, exec, ghostty"
        "SUPER, X, exec, ghostty"
        # MPD binds
        "SUPER, F1, exec, ghostty --class=com.ghostty.mpd-picker -e fish -c mpd_picker"
        "SUPER, F2, exec, mpc toggle"
        "SUPER, F3, exec, mpc prev"
        "SUPER, F4, exec, mpc next"
        "SUPER, F8, exec, ghostty --class=com.ghostty.real-book-picker -e fish -c real_book_picker"
        # Scratchpad
        "SUPER SHIFT, Backspace, togglespecialworkspace, scratchpad"
        "SUPER, Backspace, movetoworkspace, special:scratchpad"
        "SUPER CTRL, Backspace, workspace, special:scratchpad"
        "SUPER CTRL, Space, exec, noctalia-shell ipc call followMode toggle"
        # Screenshots
        ", Print, exec, hyprland-screenshot-screen"
        "SHIFT, Print, exec, hyprland-screenshot-region"
        "CTRL, Print, exec, hyprland-screenshot-window"
        # Japanese keyboard
        ", Muhenkan, movefocus, l"
        ", Henkan_Mode, movefocus, r"
        "SHIFT, Muhenkan, movefocus, u"
        "SHIFT, Henkan_Mode, movefocus, d"
        "SUPER SHIFT, Muhenkan, movewindow, u"
        "SUPER SHIFT, Henkan_Mode, movewindow, d"
        ", Hiragana_Katakana, exec, noctalia-shell ipc call overview toggle"
        # Noctalia system binds
        "SUPER SHIFT, C, exec, noctalia-shell ipc call lockScreen lock"
        "SUPER, Space, exec, noctalia-shell ipc call launcher toggle"
        # Media keys
        ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
        ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
        ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
        ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "SUPER SHIFT, mouse:272, resizewindow"
      ];
    };
  };
}
