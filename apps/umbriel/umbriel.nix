{
  pkgs,
  config,
  domain,
  ...
}:
let
  toml = (pkgs.formats.toml { }).generate "umbriel-config.toml";
  colors = config.lib.stylix.colors.withHashtag;

  floatRule =
    match: extra:
    {
      inherit match;
      default_floating = true;
    }
    // extra;

  pickerGeometry = {
    default_floating_size = {
      width = 0.4;
      height = 0.3;
    };
    default_position = {
      x = 0;
      y = 0;
      anchor = "top_left";
    };
  };

  screenshotDir = "~/Nextcloud/30-39_Images/32_Captures-d-écran/32.21_Captures-d-écran_Umbriel";
  screenshot =
    extra:
    "mkdir -p ${screenshotDir} && grim ${extra} ${screenshotDir}/$(date +%Y-%m-%d_%H-%M-%S)_umbriel.png";
  screenshotBind = extra: {
    action = "spawn sh -c '${screenshot extra}'";
    repeat = false;
  };
in
{
  home.packages = with pkgs; [
    grim
    slurp
  ];

  xdg.configFile."umbriel/config.toml".source = toml {
    include.optional.files = [ "~/.config/umbriel/local.toml" ];

    general = {
      mod_key = "Super";
      autostart = [ "noctalia" ];
      show_cheatsheet = false;
      xwayland = true;
    };

    environment = {
      NIXOS_OZONE_WL = "1";
      GTK_IM_MODULE = "simple";
    };

    input = {
      keyboard = {
        layout = "us";
        variant = "intl";
        options = "ctrl:nocaps,shift:both_capslock,lv3:menu_switch";
        repeat_rate = 60;
        repeat_delay = 200;
      };

      focus.follows_mouse = true;

      touchpad = {
        tap = true;
        natural_scroll = true;
        click_method = "clickfinger";
      };

      cursor.hide_timeout_ms = 5000;
    };

    # layout = {
    #   gap = 16;
    #   extent_presets = [
    #     0.25
    #     0.3333
    #     0.5
    #     0.6667
    #   ];
    # };

    # appearance = {
    #   border_width = 4;
    #   corner_radius = 12;
    #   shadow.enabled = false;
    #   blur = {
    #     enabled = true;
    #     optimized = true;
    #     passes = 3;
    #     radius = 5;
    #     noise = 0.0;
    #     saturation = 1.5;
    #   };
    # };

    colors.border = {
      focused = colors.base0D;
      unfocused = colors.base03;
      outer = colors.base00;
    };

    output = {
      "AU Optronics 0x116D Unknown" = {
        scale = 2.0;
        position = [
          0
          0
        ];
      };
      "LG Display 0x067C Unknown" = {
        scale = 2.0;
      };
      "Samsung Electric Company Q90A 0x01000E00" = {
        scale = 2.0;
        mode = "3840x2160@60";
      };
      "Dell Inc. DELL S2721DGF 6C1TR83" = {
        mode = "2560x1440@143.912";
        position = [
          0
          0
        ];
      };
      "LG Display 0x05EF Unknown" = {
        scale = 1.6;
        mode = "2560x1440@59.998";
      };
      "LG Electronics LG IPS FULLHD 0x01010101" = {
        position = [
          0
          0
        ];
      };
      "eDP-1" = {
        scale = 1.25;
      };
    };

    window_rule = [
      { blur = true; }
      (floatRule { app_id = "^mpv$"; } { })
      (floatRule { app_id = "^swayimg$"; } { })
      (floatRule { app_id = "^imv$"; } { })
      (floatRule { app_id = "^zoom$"; } { })
      (floatRule { app_id = "^org[.]keepassxc[.]KeePassXC$"; } {
        block_capture = true;
      })
      (floatRule {
        app_id = "^steam$";
        title = "^Friends List$";
      } { })
      (floatRule {
        app_id = "^steam$";
        title = "^Steam Settings$";
      } { })
      (floatRule { title = "^(Ouvrir|Open|Enregistrer|Extension|Add).*$"; } { })
      (floatRule { app_id = "^com[.]ghostty[.]mpd-picker$"; } pickerGeometry)
      (floatRule { app_id = "^com[.]ghostty[.]real-book-picker$"; } pickerGeometry)
      # {
      #   match.is_focused = false;
      #   opacity = 0.90;
      # }
    ];

    # layer_rule = [
    #   {
    #     match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
    #     blur = true;
    #     blur_ignore_alpha = 0.5;
    #     blur_popups = true;
    #   }
    #   {
    #     match.namespace = "^noctalia-(notification|dock|panel|attached-panel|osd)$";
    #     blur_optimized = false;
    #   }
    # ];

    keybinds = {
      # launcher, applications, session
      "Mod" = "spawn noctalia msg panel-toggle launcher";
      "Mod+Return" = {
        action = "spawn ghostty";
        repeat = false;
      };
      "Mod+X" = {
        action = "spawn ghostty";
        repeat = false;
      };
      "Mod+Z" = {
        action = "spawn zen-twilight";
        repeat = false;
      };
      "Mod+S" = {
        action = "spawn steam";
        repeat = false;
      };
      "Mod+Shift+S" = {
        action = "spawn jellyfin-media-server";
        repeat = false;
      };
      "Mod+Y" = {
        action = "spawn nextcloud";
        repeat = false;
      };
      "Mod+B" = {
        action = "spawn chromium";
        repeat = false;
      };
      "Mod+T" = {
        action = "spawn soffice";
        repeat = false;
      };
      "Mod+Shift+T" = {
        action = "spawn gnome-system-monitor";
        repeat = false;
      };
      "Mod+D" = {
        action = "spawn feishin";
        repeat = false;
      };
      "Mod+Shift+D" = {
        action = "spawn chromium --app=https://covertone.homelab.${domain}";
        repeat = false;
      };
      "Mod+N" = {
        action = "spawn keepassxc";
        repeat = false;
      };
      "Mod+F8" = {
        action = "spawn ghostty --class=com.ghostty.real-book-picker -e fish -c real_book_picker";
        repeat = false;
      };
      "Mod+Q" = {
        action = "window-close";
        repeat = false;
      };
      "Mod+Shift+E" = {
        action = "session-quit";
        repeat = false;
      };
      "Mod+Shift+P" = {
        action = "spawn poweroff";
        repeat = false;
      };
      "Mod+Shift+O" = {
        action = "spawn reboot";
        repeat = false;
      };
      "Mod+Shift+Slash" = {
        action = "cheatsheet-toggle";
        repeat = false;
      };

      "Mod+F" = {
        action = "window-toggle-maximize";
        repeat = false;
      };
      "Mod+Shift+F" = {
        action = "window-toggle-fullscreen";
        repeat = false;
      };
      "Mod+V" = {
        action = "window-toggle-floating";
        repeat = false;
      };
      "Mod+Shift+V" = {
        action = "window-focus-switch-floating";
        repeat = false;
      };
      "Mod+W" = {
        action = "column-toggle-tabbed";
        repeat = false;
      };
      "Mod+C" = {
        action = "column-center";
        repeat = false;
      };
      "Mod+BracketLeft" = "window-consume-or-expel-left";
      "Mod+BracketRight" = "window-consume-or-expel-right";
      "Mod+Comma" = "window-consume-left";
      "Mod+R" = "window-cycle-primary-extent";
      "Mod+Shift+R" = "window-cycle-secondary-extent";
      "Mod+Minus" = "window-modify-primary-extent -0.1";
      "Mod+Equal" = "window-modify-primary-extent +0.1";
      "Mod+Shift+Minus" = "window-modify-secondary-extent -0.1";
      "Mod+Shift+Equal" = "window-modify-secondary-extent +0.1";

      "Mod+Alt+Space" = "workspace-set-layout toggle";
      "Mod+Alt+1" = "workspace-set-layout scrolling";
      "Mod+Alt+2" = "workspace-set-layout dwindle";
      "Mod+Alt+3" = "workspace-set-layout master";
      "Mod+Alt+4" = "workspace-set-layout stacking";

      "Mod+Alt+S" = "layout-toggle-split";
      "Mod+Alt+Equal" = "layout-master-count-increase";
      "Mod+Alt+Minus" = "layout-master-count-decrease";

      "Mod+Alt+H" = "window-set-region left";
      "Mod+Alt+L" = "window-set-region right";
      "Mod+Alt+K" = "window-set-region top";
      "Mod+Alt+J" = "window-set-region bottom";
      "Mod+Alt+C" = "window-clear-region";

      "Mod+Alt+Right" = "column-focus-tab-next";
      "Mod+Alt+Left" = "column-focus-tab-previous";

      "Mod+H" = "window-focus-left";
      "Mod+L" = "window-focus-right";
      "Mod+J" = "window-focus-or-workspace-down";
      "Mod+K" = "window-focus-or-workspace-up";
      "Mod+Left" = "window-focus-left";
      "Mod+Right" = "window-focus-right";
      "Mod+Down" = "window-focus-or-workspace-down";
      "Mod+Up" = "window-focus-or-workspace-up";

      "Mod+Ctrl+H" = "output-focus-left";
      "Mod+Ctrl+L" = "output-focus-right";
      "Mod+Ctrl+J" = "output-focus-down";
      "Mod+Ctrl+K" = "output-focus-up";
      "Mod+Ctrl+Left" = "output-focus-left";
      "Mod+Ctrl+Right" = "output-focus-right";
      "Mod+Ctrl+Down" = "output-focus-down";
      "Mod+Ctrl+Up" = "output-focus-up";

      "Mod+Shift+H" = "column-move-left";
      "Mod+Shift+L" = "column-move-right";
      "Mod+Shift+J" = "window-move-or-workspace-down";
      "Mod+Shift+K" = "window-move-or-workspace-up";
      "Mod+Shift+Left" = "column-move-left";
      "Mod+Shift+Right" = "column-move-right";
      "Mod+Shift+Down" = "window-move-or-workspace-down";
      "Mod+Shift+Up" = "window-move-or-workspace-up";

      "Mod+Ctrl+Shift+H" = "column-move-to-output-left";
      "Mod+Ctrl+Shift+L" = "column-move-to-output-right";
      "Mod+Ctrl+Shift+J" = "column-move-to-output-down";
      "Mod+Ctrl+Shift+K" = "column-move-to-output-up";
      "Mod+Ctrl+Shift+Left" = "column-move-to-output-left";
      "Mod+Ctrl+Shift+Right" = "column-move-to-output-right";
      "Mod+Ctrl+Shift+Down" = "column-move-to-output-down";
      "Mod+Ctrl+Shift+Up" = "column-move-to-output-up";

      "Mod+1" = "workspace-switch 1";
      "Mod+2" = "workspace-switch 2";
      "Mod+3" = "workspace-switch 3";
      "Mod+4" = "workspace-switch 4";
      "Mod+5" = "workspace-switch 5";
      "Mod+6" = "workspace-switch 6";
      "Mod+7" = "workspace-switch 7";
      "Mod+8" = "workspace-switch 8";
      "Mod+9" = "workspace-switch 9";
      "Mod+Shift+1" = "column-move-to-workspace 1";
      "Mod+Shift+2" = "column-move-to-workspace 2";
      "Mod+Shift+3" = "column-move-to-workspace 3";
      "Mod+Shift+4" = "column-move-to-workspace 4";
      "Mod+Shift+5" = "column-move-to-workspace 5";
      "Mod+Shift+6" = "column-move-to-workspace 6";
      "Mod+Shift+7" = "column-move-to-workspace 7";
      "Mod+Shift+8" = "column-move-to-workspace 8";
      "Mod+Shift+9" = "column-move-to-workspace 9";
      "Mod+U" = "workspace-next";
      "Mod+I" = "workspace-previous";
      "Mod+Shift+U" = "column-move-to-workspace-next";
      "Mod+Shift+I" = "column-move-to-workspace-previous";

      "Mod+WheelUp" = {
        action = "window-focus-left";
        cooldown_ms = 50;
      };
      "Mod+WheelDown" = {
        action = "window-focus-right";
        cooldown_ms = 50;
      };
      "Mod+Shift+WheelUp" = {
        action = "window-focus-or-workspace-up";
        cooldown_ms = 50;
      };
      "Mod+Shift+WheelDown" = {
        action = "window-focus-or-workspace-down";
        cooldown_ms = 50;
      };

      "Mod+Tab" = {
        action = "overview-toggle";
        repeat = false;
      };
      "Hiragana_Katakana" = {
        action = "overview-toggle";
        repeat = false;
      };
      "XF86NotificationCenter" = {
        action = "overview-toggle";
        repeat = false;
      };
      "XF86PickupPhone" = {
        action = "overview-toggle";
        repeat = false;
      };
      "XF86HangupPhone" = {
        action = "overview-toggle";
        repeat = false;
      };
      "XF86Favorites" = {
        action = "overview-toggle";
        repeat = false;
      };
      "Mod+Shift+Backspace" = {
        action = "window-move-to-scratchpad";
        repeat = false;
      };
      "Mod+Backspace" = "scratchpad-toggle";
      "Mod+Ctrl+Space" = {
        action = "scratchpad-focus-next";
        repeat = false;
      };

      "Muhenkan" = "window-focus-left";
      "Henkan_Mode" = "window-focus-right";
      "Shift+Muhenkan" = "window-focus-or-workspace-up";
      "Shift+Henkan_Mode" = "window-focus-or-workspace-down";
      "Mod+Shift+Muhenkan" = "window-move-or-workspace-up";
      "Mod+Shift+Henkan_Mode" = "window-move-or-workspace-down";

      "Print" = screenshotBind "";
      "Shift+Print" = screenshotBind ''-g "$(slurp)"'';

      "XF86AudioRaiseVolume" = {
        action = "spawn noctalia msg volume-up";
        allow_when_locked = true;
      };
      "XF86AudioLowerVolume" = {
        action = "spawn noctalia msg volume-down";
        allow_when_locked = true;
      };
      "XF86AudioMute" = {
        action = "spawn noctalia msg volume-mute";
        allow_when_locked = true;
        repeat = false;
      };
      "XF86AudioPlay" = {
        action = "spawn noctalia msg media toggle";
        allow_when_locked = true;
        repeat = false;
      };
      "XF86AudioNext" = {
        action = "spawn noctalia msg media next";
        allow_when_locked = true;
      };
      "XF86AudioPrev" = {
        action = "spawn noctalia msg media previous";
        allow_when_locked = true;
      };
      "XF86MonBrightnessUp" = {
        action = "spawn noctalia msg brightness-up";
        allow_when_locked = true;
      };
      "XF86MonBrightnessDown" = {
        action = "spawn noctalia msg brightness-down";
        allow_when_locked = true;
      };
    };
  };
}
