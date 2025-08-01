{
  inputs,
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    libnotify
    grim
    slurp
    pamixer
  ];
  home.file.".local/bin/wrappedhl".source = ./wrappedhl;
  home.file = {
    "scripts".source = pkgs.fetchFromGitHub {
      owner = "dbeley";
      repo = "scripts";
      rev = "a8607fbfb8c50543629e14ec483473459229091d";
      sha256 = "XBumWlu4+z/jTKLK71Lr0hMeLhc43XD3oEzY+YUMzN4=";
    };
  };
  wayland.windowManager.hyprland = {
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    enable = true;
    xwayland.enable = true;
    plugins = [
      inputs.hyprgrass.packages.${pkgs.system}.default
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprspace.packages.${pkgs.system}.Hyprspace
    ];
    settings = {
      "$MOD" = "SUPER";
      "$TERMINAL" = "kitty";
      "$BROWSER" = "firefox";
      "$MENU" = "tofi-run | xargs hyprctl dispatch exec";
      "$SCREENSHOT_FOLDER" =
        "~/Nextcloud/10-19_Images/11_Captures-d-écran/11.08_Captures-d-écran_Hyprland";
      xwayland = {
        force_zero_scaling = true;
      };
      ecosystem.no_update_news = true;
      env = [
        "XCURSOR_SIZE,24"
        # "QT_SCALE_FACTOR_ROUNDING_POLICY,RoundPreferFloor"
      ];
      monitor = [
        ",preferred,auto,auto"
        "eDP-1,preferred,auto,1.6"
        "desc:AU Optronics 0xFA9B,preferred,auto,1.2"
        "desc:Lenovo Group Limited 0x403D,preferred,auto,1.2"
        "desc:Dell Inc. DELL S2721DGF 6C1TR83,preferred,0x0,1" # Dell 27"
        "desc:Lenovo Group Limited 0x4094,preferred,auto,1.2"
        "desc:LG Display 0x067C,preferred,auto,2" # LG ultra-wide
        "desc:LG Display 0x05EF,preferred,auto,1.6" # Thinkpad X1 Yoga
        "desc:Samsung Electric Company Q90A 0x01000E00,preferred,auto,2" # Samsung TV
      ];
      exec-once = [
        "keepassxc"
        "command -v wvkbd-mobintl && wvkbd-mobintl -L 250 --hidden"
        "command -v iio-hyprland && iio-hyprland"
      ];
      input = {
        kb_layout = "us";
        kb_variant = "intl";
        kb_model = "";
        kb_options = "ctrl:nocaps,shift:both_capslock";
        kb_rules = "";
        follow_mouse = 1;
        left_handed = true;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
        repeat_rate = 60;
        repeat_delay = 200;
      };
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        resize_on_border = true;
        layout = "master";
        allow_tearing = false;
      };
      cursor = {
        inactive_timeout = 3;
      };
      decoration = {
        rounding = 10;
        inactive_opacity = 0.8;
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
          new_optimizations = true;
          xray = true;
          ignore_opacity = true;
        };
        shadow = {
          enabled = false;
          #   range = 4;
          #   render_power = 3;
          #   color = "rgba(1a1a1aee)";
        };
      };
      animations = {
        enabled = true;
        # bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        # animation = [
        #   "windows, 1, 7, myBezier"
        #   "windowsOut, 1, 7, default, popin 80%"
        #   "border, 1, 10, default"
        #   "borderangle, 1, 8, default"
        #   "fade, 1, 7, default"
        #   "workspaces, 1, 6, default"
        # ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master = {
        new_status = "slave";
        orientation = "center";
        slave_count_for_center_master = 2;
        center_master_fallback = "right";
        mfact = 0.6;
      };
      gestures = {
        workspace_swipe = true;
      };
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = true;
      };
      bind = [
        "$MOD, return, exec, $TERMINAL"
        "$MOD, z, exec, $BROWSER"
        "$MOD SHIFT, z, exec, emacs"
        "$MOD, x, exec, $TERMINAL"
        "$MOD SHIFT, x, exec, steam"
        "$MOD, c, exec, soffice"
        "$MOD SHIFT, c, exec, hyprlock"
        "$MOD, t, exec, soffice"
        "$MOD SHIFT, t, exec, gnome-system-monitor"
        "$MOD, d, exec, supersonic"
        "$MOD, e, exec, $MENU"
        "$MOD, q, killactive"
        "$MOD, v, togglefloating"
        "$MOD, p, pseudo"
        "$MOD, s, togglesplit"
        "$MOD SHIFT, s, pin"
        "$MOD, m, fullscreen"
        "$MOD, w, togglegroup"
        "$MOD, page_down, changegroupactive, b"
        "$MOD, page_up, changegroupactive, f"
        "$MOD, left, movefocus, l"
        "$MOD, right, movefocus, r"
        "$MOD, up, movefocus, u"
        "$MOD, down, movefocus, d"
        "$MOD, h, movefocus, l"
        "$MOD, l, movefocus, r"
        "$MOD, k, movefocus, u"
        "$MOD, j, movefocus, d"
        "$MOD SHIFT, left, movewindow, l"
        "$MOD SHIFT, right, movewindow, r"
        "$MOD SHIFT, up, movewindow, u"
        "$MOD SHIFT, down, movewindow, d"
        "$MOD SHIFT, h, movewindow, l"
        "$MOD SHIFT, l, movewindow, r"
        "$MOD SHIFT, k, movewindow, u"
        "$MOD SHIFT, j, movewindow, d"
        "$MOD, n, togglespecialworkspace, scratchpad"
        "$MOD SHIFT, g, movetoworkspace, special:scratchpad"
        "$MOD, g, togglespecialworkspace, scratchpad2"
        "$MOD SHIFT, g, movetoworkspace, special:scratchpad2"
        "$MOD, d, togglespecialworkspace, scratchpad3"
        "$MOD SHIFT, d, movetoworkspace, special:scratchpad3"
        "$MOD, mouse_down, workspace, e+1"
        "$MOD, mouse_up, workspace, e-1"
        ", xf86display, exec, ~/scripts/toggle_gammastep.sh"
        "SHIFT, xf86display, exec, ~/scripts/hyprland_switch_monitor.sh eDP-1"
        ", print, exec, grim $SCREENSHOT_FOLDER/\"$(date +%Y-%m-%d_%H:%M:%S_%s)\"_hyprland.png"
        "SHIFT, print, exec, grim -g \"$(slurp -d)\" $SCREENSHOT_FOLDER/\"$(date +%Y-%m-%d_%H:%M:%S_%s)\"_hyprland_cropped.png"
        "$MOD, Tab, overview:toggle"
        "$MOD SHIFT, Tab, hyprexpo:expo, toggle"
        "$MOD, a, layoutmsg, cyclenext"
        "$MOD SHIFT, m, layoutmsg, swapwithmaster"
        "$MOD, y, exec, hyprctl keyword general:layout \"dwindle\""
        "$MOD SHIFT, y, exec, hyprctl keyword general:layout \"master\""
      ]
      ++ (
        # workspaces
        # binds $MOD + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i;
            in
            [
              "$MOD, ${toString i}, workspace, ${toString ws}"
              "$MOD SHIFT, ${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      );
      binde = [
        # xf86bluetooth
        # xf86keyboard
        # xf86tools
        # xf86audiomicmute
        # xf86display
        # xf86wlan
        # xf86messenger
        # xf86go
        # cancel
        # xf86favorites
        ", xf86audiomute, exec, ~/scripts/volume_pamixer.sh mute"
        ", xf86audiolowervolume, exec, ~/scripts/volume_pamixer.sh down"
        "SHIFT, xf86audiolowervolume, exec, ~/scripts/volume_pamixer.sh bigdown"
        ", xf86audioraisevolume, exec, ~/scripts/volume_pamixer.sh up"
        "SHIFT, xf86audioraisevolume, exec, ~/scripts/volume_pamixer.sh bigup"
        ", xf86monbrightnessdown, exec, brightnessctl s 5%-"
        ", xf86monbrightnessup, exec, brightnessctl s +5%"
      ];
      bindm = [
        "$MOD, mouse:272, movewindow"
        "$MOD, mouve:273, resizewindow"
      ];
      windowrulev2 = [
        "suppressevent maximize, class:.*" # You'll probably like this.
        "float,class:org.keepassxc.KeePassXC"
        "float,class:zoom"
        "workspace special:scratchpad silent,class:org.keepassxc.KeePassXC"
        "workspace special:scratchpad3 silent,class:Supersonic"
        "float,class:mpv"
        "opaque,class:mpv"
        "float,title:^(swayimg)(.*)$"
        "float,title:^(imv)(.*)$"
        "float,title:^(Ouvrir)(.*)$"
        "float,title:^(Extension)(.*)$"
        "float,title:^(Add)(.*)$"
        "float,title:^(Friends List)$"
        "float,title:^(Steam Settings)$"
        "float,title:^(Picture-in-Picture)$"
        "pin,title:^(Picture-in-Picture)$"
        "noshadow,title:^(Picture-in-Picture)$"
        "opaque,title:^(Picture-in-Picture)$"
        "size 25% 25%,title:^(Picture-in-Picture)$"
        "move 100%-w-20,title:^(Picture-in-Picture)$"
        "noinitialfocus,title:^(Picture-in-Picture)$"
        "fullscreen,class:gamescope"
        "forcergbx,class:gamescope"
        "opaque,title:(.*)(- YouTube)(.*)$"
        "nofocus,class:^jetbrains-(?!toolbox),floating:1,title:^win\d+$"
        "dimaround,class:^(jetbrains-.*)$,floating:1,title:^(?!win)"
        "center,class:^(jetbrains-.*)$,floating:1,title:^(?!win)"
        "noanim,class:^(jetbrains-.*)$,title:^(win.*)$"
        "noinitialfocus,class:^(jetbrains-.*)$,title:^(win.*)$"
        "rounding 0,class:^(jetbrains-.*)$,title:^(win.*)$"
      ];
      plugin = {
        touch_gestures = {
          sensitivity = 4.0;
          workspace_swipe_fingers = 4;
          workspace_swipe_edge = "d";
          long_press_delay = 400;
          resize_on_border_long_press = true;
          edge_margin = 10;
          experimental = {
            send_cancel = 0;
          };
          hyprgrass-bind = [
            ", edge:r:l, workspace, +1"
            ", edge:l:r, workspace, -1"
            ", edge:u:d, fullscreen"
            ", edge:d:u, exec, pkill -SIGRTMIN wvkbd-mobintl"
            ", edge:l:u, exec, pkill -SIGRTMIN wvkbd-mobintl"
            ", edge:l:d, exec, pkill -SIGRTMIN wvkbd-mobintl"
            ", swipe:3:u, fullscreen"
            ", swipe:3:d, fullscreen"
            ", swipe:4:u, exec, ~/scripts/volume_pamixer.sh mute"
            ", swipe:4:d, killactive"
            ", swipe:5:u, exec, brightnessctl s +5%"
            ", swipe:5:d, exec, brightnessctl s 5%-"
            ", swipe:3:l, movefocus, l"
            ", swipe:3:r, movefocus, r"
            ", swipe:3:ld, exec, nautilus"
            ", swipe:3:rd, exec, $BROWSER"
            ", swipe:3:lu, exec, $TERMINAL"
            ", swipe:3:ru, exec, chromium"
            ", tap:3, exec, ~/scripts/volume_pamixer.sh bigup"
            ", tap:4, exec, ~/scripts/volume_pamixer.sh bigdown"
          ];
          hyprgrass-bindm = [
            ", longpress:2, movewindow"
            ", longpress:3, resizewindow"
          ];
        };
        overview = {
          drawActiveWorkspace = false;
        };
        hyprexpo = {
          #   columns = 3;
          #   gap_size = 5;
          #   # bg_col = "rgb(111111)";
          #   workspace_method = "center current";
          enable_gesture = false;
          #   gesture_fingers = 3;
          #   gesture_distance = 300;
          #   gesture_positive = true;
        };
      };
    };
    extraConfig = ''
      # Submap resize
      bind = $MOD, r, submap, resize # will switch to a submap called resize
      submap = resize # will start a submap called "resize"
      binde = , h, resizeactive, -50 0
      binde = , j, resizeactive, 0 50
      binde = , k, resizeactive, 0 -50
      binde = , l, resizeactive, 50 0
      bind = , escape, submap, reset # use reset to go back to the global submap
      bind = , q, submap, reset # use reset to go back to the global submap
      submap = reset # will reset the submap, meaning end the current one and return to the global one.

      # Poweroff menu
      bind = $MOD SHIFT, q, submap, poweroff
      submap = poweroff
      bind = , p, exec, poweroff
      bind = , r, exec, reboot
      bind = , s, exec, systemctl suspend
      bind = , m, exit,
      bind = , l, exec, hyprlock
      bind = , q, submap, reset
      bind = , escape, submap, reset
      submap = reset # will reset the submap, meaning end the current one and return to the global one.
    '';
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ config.stylix.image ];
      wallpaper = [
        "eDP-1,${config.stylix.image}"
        "DP-3,${config.stylix.image}"
        "DP-5,${config.stylix.image}"
        "HDMI-A-1,${config.stylix.image}"
      ];
    };
  };
}
