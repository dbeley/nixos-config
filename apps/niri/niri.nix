{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    wl-clipboard-rs
    nirius
  ];

  wayland.windowManager.niri = {
    enable = true;
    package = pkgs.niri-unstable;

    settings = {
      environment = {
        NIXOS_OZONE_WL = "1";
        DISPLAY = ":0";
        GTK_IM_MODULE = "simple";
      };

      input = {
        keyboard = {
          repeat-delay = 200;
          repeat-rate = 60;
          xkb = {
            layout = "us";
            options = "ctrl:nocaps,shift:both_capslock,lv3:menu_switch";
            variant = "intl";
          };
        };
        mouse = {
          "left-handed" = [ ];
        };
        touchpad = {
          "left-handed" = [ ];
          tap = [ ];
          dwt = [ ];
          "natural-scroll" = [ ];
          "click-method" = "clickfinger";
        };
        trackpoint = {
          "left-handed" = [ ];
        };
        trackball = {
          "left-handed" = [ ];
        };
        "focus-follows-mouse" = [ ];
      };

      output = [
        {
          _args = [ "LG Display 0x067C Unknown" ];
          scale = 2;
        }
        {
          _args = [ "Samsung Electric Company Q90A 0x01000E00" ];
          scale = 2;
          mode = "3840x2160@60";
        }
        {
          _args = [ "Dell Inc. DELL S2721DGF 6C1TR83" ];
          mode = "2560x1440@143.912";
          position._props = {
            x = 0;
            y = 0;
          };
        }
        {
          _args = [ "LG Display 0x05EF Unknown" ];
          scale = 1.6;
          mode = "2560x1440@59.998";
        }
        {
          _args = [ "LG Electronics LG IPS FULLHD 0x01010101" ];
          position._props = {
            x = 0;
            y = 0;
          };
        }
        {
          _args = [ "eDP-1" ];
          scale = 1.25;
        }
      ];

      cursor = {
        hide-after-inactive-ms = 5000;
      };

      layout = {
        gaps = 16;
        focus-ring = {
          off = [ ];
        };
        border = with config.lib.stylix.colors.withHashtag; {
          on = [ ];
          width = 4;
          active-color = base0D;
          inactive-color = base03;
        };

        preset-column-widths._children = [
          { proportion = 1.0 / 2.0; }
          { proportion = 1.0 / 3.0; }
          { proportion = 2.0 / 3.0; }
          { proportion = 1.0 / 4.0; }
        ];
        preset-window-heights._children = [
          { proportion = 1.0 / 2.0; }
          { proportion = 1.0 / 3.0; }
          { proportion = 2.0 / 3.0; }
          { proportion = 1.0 / 4.0; }
        ];
      };

      prefer-no-csd = true;
      screenshot-path = "~/Nextcloud/30-39_Images/32_Captures-d-écran/32.19_Captures-d-écran_Niri/%Y-%m-%d %H-%M-%S.png";

      blur = {
        passes = 3;
        offset = 4.0;
        noise = 0.0;
        saturation = 1.5;
      };

      spawn-at-startup = [
        [ "niriusd" ]
      ];

      window-rule = [
        {
          match = [
            {
              _props = {
                app-id = "firefox";
                title = "Picture-in-Picture";
              };
            }
            { _props.app-id = "mpv"; }
            {
              _props = {
                app-id = "steam";
                title = "Friends List";
              };
            }
            {
              _props = {
                app-id = "steam";
                title = "Steam Settings";
              };
            }
            {
              _props = {
                app-id = "jetbrains.*";
                title = "Open File or Project";
              };
            }
            {
              _props = {
                app-id = "jetbrains.*";
                title = "Settings";
              };
            }
            {
              _props = {
                app-id = "jetbrains.*";
                title = "Confirm Exit";
              };
            }
            {
              _props = {
                app-id = "jetbrains.*";
                title = "Update Project";
              };
            }
            {
              _props = {
                app-id = "zoom";
                title = "Zoom Workplace";
              };
            }
            {
              _props = {
                app-id = "zoom";
                title = "Settings";
              };
            }
            {
              _props = {
                app-id = "zoom";
                title = "zoom";
              };
            }
            { _props.app-id = "swayimg"; }
            { _props.title = "Ouvrir.*"; }
            { _props.title = "Extension.*"; }
            { _props.title = "Enregistrer.*"; }
            { _props.title = "Add.*"; }
          ];
          open-floating = true;
        }
        {
          match._props.app-id = "org.keepassxc.KeePassXC";
          block-out-from = "screen-capture";
        }
        {
          match = [
            { _props.app-id = "com.ghostty.mpd-picker"; }
            { _props.app-id = "com.ghostty.real-book-picker"; }
          ];
          open-floating = true;
          "default-floating-position"._props = {
            x = 0;
            y = 0;
            relative-to = "top";
          };
          default-window-height = {
            proportion = 0.3;
          };
          default-column-width = {
            proportion = 0.4;
          };
        }
        {
          "geometry-corner-radius"._args = [
            12.0
            12.0
            12.0
            12.0
          ];
          "clip-to-geometry" = true;
          background-effect = {
            blur = true;
            xray = true;
          };
          "draw-border-with-background" = false;
        }
        {
          match = [
            { _props."is-focused" = false; }
          ];
          opacity = 0.90;
        }
      ];

      layer-rule = [
        {
          match = [
            { _props.namespace = "noctalia-wallpaper*"; }
          ];
          "place-within-backdrop" = true;
        }
      ];
      layout.background-color = "transparent";
      overview.workspace-shadow = {
        off = [ ];
      };

      hotkey-overlay = {
        skip-at-startup = true;
      };

      include = [
        {
          _args = [ "~/.config/niri/local.kdl" ];
          _props.optional = true;
        }
      ];

      binds = {
        "Mod+Shift+Slash"."show-hotkey-overlay" = [ ];
        "XF86NotificationCenter"."toggle-overview" = [ ];
        "XF86PickupPhone"."toggle-overview" = [ ];
        "XF86HangupPhone"."toggle-overview" = [ ];
        "XF86Favorites"."toggle-overview" = [ ];

        "Mod+1"."focus-workspace" = 1;
        "Mod+2"."focus-workspace" = 2;
        "Mod+3"."focus-workspace" = 3;
        "Mod+4"."focus-workspace" = 4;
        "Mod+5"."focus-workspace" = 5;
        "Mod+6"."focus-workspace" = 6;
        "Mod+7"."focus-workspace" = 7;
        "Mod+8"."focus-workspace" = 8;
        "Mod+9"."focus-workspace" = 9;

        "Mod+Shift+1"."move-column-to-workspace" = 1;
        "Mod+Shift+2"."move-column-to-workspace" = 2;
        "Mod+Shift+3"."move-column-to-workspace" = 3;
        "Mod+Shift+4"."move-column-to-workspace" = 4;
        "Mod+Shift+5"."move-column-to-workspace" = 5;
        "Mod+Shift+6"."move-column-to-workspace" = 6;
        "Mod+Shift+7"."move-column-to-workspace" = 7;
        "Mod+Shift+8"."move-column-to-workspace" = 8;
        "Mod+Shift+9"."move-column-to-workspace" = 9;

        "Mod+Shift+E"."quit" = [ ];
        "Mod+Shift+P"."spawn" = [ "poweroff" ];
        "Mod+Shift+O"."spawn" = [ "reboot" ];

        "Mod+F"."maximize-column" = [ ];
        "Mod+Shift+F"."fullscreen-window" = [ ];
        "Mod+Q"."close-window" = [ ];
        "Mod+V"."toggle-window-floating" = [ ];
        "Mod+Shift+V"."switch-focus-between-floating-and-tiling" = [ ];
        "Mod+W"."toggle-column-tabbed-display" = [ ];
        "Mod+C"."center-column" = [ ];
        "Mod+BracketLeft"."consume-or-expel-window-left" = [ ];
        "Mod+BracketRight"."consume-or-expel-window-right" = [ ];
        "Mod+Comma"."consume-window-into-column" = [ ];
        "Mod+Period"."expel-window-from-column" = [ ];
        "Mod+R"."switch-preset-column-width" = [ ];
        "Mod+Shift+R"."switch-preset-window-height" = [ ];
        "Mod+Ctrl+R"."reset-window-height" = [ ];
        "Mod+Shift+Ctrl+R"."reset-window-height" = [ ];
        "Mod+Minus"."set-column-width" = "-10%";
        "Mod+Equal"."set-column-width" = "+10%";
        "Mod+Shift+Minus"."set-window-height" = "-10%";
        "Mod+Shift+Equal"."set-window-height" = "+10%";

        "Mod+H"."focus-column-left" = [ ];
        "Mod+J"."focus-window-or-workspace-down" = [ ];
        "Mod+K"."focus-window-or-workspace-up" = [ ];
        "Mod+L"."focus-column-right" = [ ];
        "Mod+Left"."focus-column-left" = [ ];
        "Mod+Down"."focus-window-or-workspace-down" = [ ];
        "Mod+Up"."focus-window-or-workspace-up" = [ ];
        "Mod+Right"."focus-column-right" = [ ];

        "Mod+Ctrl+H"."focus-monitor-left" = [ ];
        "Mod+Ctrl+J"."focus-monitor-down" = [ ];
        "Mod+Ctrl+K"."focus-monitor-up" = [ ];
        "Mod+Ctrl+L"."focus-monitor-right" = [ ];
        "Mod+Ctrl+Left"."focus-monitor-left" = [ ];
        "Mod+Ctrl+Down"."focus-monitor-down" = [ ];
        "Mod+Ctrl+Up"."focus-monitor-up" = [ ];
        "Mod+Ctrl+Right"."focus-monitor-right" = [ ];

        "Mod+Shift+H"."move-column-left" = [ ];
        "Mod+Shift+J"."move-window-down-or-to-workspace-down" = [ ];
        "Mod+Shift+K"."move-window-up-or-to-workspace-up" = [ ];
        "Mod+Shift+L"."move-column-right" = [ ];
        "Mod+Shift+Left"."move-column-left" = [ ];
        "Mod+Shift+Down"."move-window-down-or-to-workspace-down" = [ ];
        "Mod+Shift+Up"."move-window-up-or-to-workspace-up" = [ ];
        "Mod+Shift+Right"."move-column-right" = [ ];

        "Mod+Ctrl+Shift+H"."move-column-to-monitor-left" = [ ];
        "Mod+Ctrl+Shift+J"."move-column-to-monitor-down" = [ ];
        "Mod+Ctrl+Shift+K"."move-column-to-monitor-up" = [ ];
        "Mod+Ctrl+Shift+L"."move-column-to-monitor-right" = [ ];
        "Mod+Ctrl+Shift+Left"."move-column-to-monitor-left" = [ ];
        "Mod+Ctrl+Shift+Down"."move-column-to-monitor-down" = [ ];
        "Mod+Ctrl+Shift+Up"."move-column-to-monitor-up" = [ ];
        "Mod+Ctrl+Shift+Right"."move-column-to-monitor-right" = [ ];

        "Mod+WheelScrollUp"."focus-column-left" = [ ];
        "Mod+WheelScrollDown"."focus-column-right" = [ ];
        "Mod+Shift+WheelScrollUp"."focus-window-or-workspace-up" = [ ];
        "Mod+Shift+WheelScrollDown"."focus-window-or-workspace-down" = [ ];

        "Mod+U"."focus-workspace-down" = [ ];
        "Mod+I"."focus-workspace-up" = [ ];
        "Mod+Shift+U"."move-column-to-workspace-down" = [ ];
        "Mod+Shift+I"."move-column-to-workspace-up" = [ ];

        "Ctrl+Print"."screenshot-window" = {
          _props."show-pointer" = true;
        };
        "Shift+Print"."screenshot" = [ ];
        "Print"."screenshot-screen" = {
          _props."show-pointer" = false;
        };

        "Mod+Z"."spawn" = [ "zen-twilight" ];
        "Mod+S"."spawn" = [ "steam" ];
        "Mod+Y"."spawn" = [ "nextcloud" ];
        "Mod+B"."spawn" = [ "chromium" ];
        "Mod+T"."spawn" = [ "soffice" ];
        "Mod+D"."spawn" = [ "feishin" ];
        "Mod+Shift+D"."spawn" = [
          "chromium"
          "--app=http://covertone.docker-era.home"
          "--disable-extensions"
        ];
        "Mod+N"."spawn" = [ "keepassxc" ];
        "Mod+Shift+T"."spawn" = [ "gnome-system-monitor" ];
        "Mod+Return"."spawn" = [ "ghostty" ];
        "Mod+X"."spawn" = [ "ghostty" ];

        "Mod+F1"."spawn" = [
          "ghostty"
          "--class=com.ghostty.mpd-picker"
          "-e"
          "fish"
          "-c"
          "mpd_picker"
        ];
        "Mod+F2"."spawn" = [
          "mpc"
          "toggle"
        ];
        "Mod+F3"."spawn" = [
          "mpc"
          "prev"
        ];
        "Mod+F4"."spawn" = [
          "mpc"
          "next"
        ];

        "Mod+F8"."spawn" = [
          "ghostty"
          "--class=com.ghostty.real-book-picker"
          "-e"
          "fish"
          "-c"
          "real_book_picker"
        ];

        "Muhenkan"."focus-column-left" = [ ];
        "Henkan_Mode"."focus-column-right" = [ ];
        "Shift+Muhenkan"."focus-window-or-workspace-up" = [ ];
        "Shift+Henkan_Mode"."focus-window-or-workspace-down" = [ ];
        "Mod+Shift+Muhenkan"."move-window-up-or-to-workspace-up" = [ ];
        "Mod+Shift+Henkan_Mode"."move-window-down-or-to-workspace-down" = [ ];
        "Hiragana_Katakana"."toggle-overview" = [ ];
        "Mod+Tab"."toggle-overview" = [ ];

        "Mod+Shift+Backspace"."spawn" = [
          "nirius"
          "scratchpad-toggle"
        ];
        "Mod+Backspace"."spawn" = [
          "nirius"
          "scratchpad-show"
        ];
        "Mod+Ctrl+Backspace"."spawn" = [
          "nirius"
          "scratchpad-show-all"
        ];
        "Mod+Ctrl+Space"."spawn" = [
          "nirius"
          "toggle-follow-mode"
        ];
      };
    };
  };
}
