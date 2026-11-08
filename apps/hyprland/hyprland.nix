{
  pkgs,
  config,
  domain,
  lib,
  ...
}:
let
  helpers = import ../scripts/scripts.nix { inherit pkgs; };

  toLua = lib.generators.toLua { };
  lua = lib.generators.mkLuaInline;

  dsp = name: arg: lua "hl.dsp.${name}(${toLua arg})";

  exec = cmd: lua "hl.dsp.exec_cmd(${toLua cmd})";

  bind = keys: dispatcher: {
    _args = [
      keys
      dispatcher
    ];
  };

  bindWith = keys: dispatcher: opts: {
    _args = [
      keys
      dispatcher
      opts
    ];
  };
  media =
    keys: cmd:
    bindWith keys (exec cmd) {
      locked = true;
      repeating = true;
    };

  focusDir = direction: dsp "focus" { inherit direction; };
  moveDir = direction: dsp "window.move" { inherit direction; };
  focusWorkspace = workspace: dsp "focus" { inherit workspace; };
  moveToWorkspace = workspace: dsp "window.move" { inherit workspace; };

  screenshotDir = "~/Nextcloud/30-39_Images/32_Captures-d-écran/32.18_Captures-d-écran_Hyprland";
  screenshot = args: ''
    mkdir -p ${screenshotDir} && grim ${args} ${screenshotDir}/$(date +%Y-%m-%d_%H-%M-%S)_hyprland.png
  '';

  launcher = exec "exec $(tofi-run)";
in
{
  home.packages = with pkgs; [
    libnotify
    grim
    slurp
    pamixer
    wl-clipboard-rs
  ];

  systemd.user.services = {
    hyprpaper = lib.mkIf config.services.hyprpaper.enable {
      Unit.ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=Hyprland";
    };
    hypridle = lib.mkIf config.services.hypridle.enable {
      Unit.ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=Hyprland";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    xwayland.enable = true;

    settings = {
      config = {
        general = {
          gaps_in = 8;
          gaps_out = 16;
          border_size = 4;
          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = false;
        };

        decoration = {
          rounding = 12;
          active_opacity = 1.0;
          inactive_opacity = 0.9;
          blur = {
            enabled = true;
            size = 5;
            passes = 3;
            xray = true;
            noise = 0.0;
          };
          shadow.enabled = false;
        };

        animations.enabled = true;

        dwindle = {
          preserve_split = true;
          smart_split = false;
        };

        master = {
          new_status = "slave";
          orientation = "center";
          slave_count_for_center_master = 2;
          center_master_fallback = "right";
          mfact = 0.6;
        };

        input = {
          kb_layout = "us";
          kb_variant = "intl";
          kb_options = "ctrl:nocaps,shift:both_capslock";
          repeat_rate = 60;
          repeat_delay = 200;
          follow_mouse = 1;
          sensitivity = 0;
          left_handed = true;
          touchpad = {
            natural_scroll = true;
            tap_to_click = true;
          };
        };

        cursor.inactive_timeout = 5;

        xwayland.force_zero_scaling = true;

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        ecosystem.no_update_news = true;
      };

      env = [
        {
          _args = [
            "XCURSOR_SIZE"
            "24"
          ];
        }
      ];

      monitor = [
        {
          output = "desc:AU Optronics 0x116D Unknown";
          scale = 2;
          position = "0x0";
        }
        {
          output = "desc:LG Display 0x067C Unknown";
          scale = 2;
        }
        {
          output = "desc:Samsung Electric Company Q90A 0x01000E00";
          mode = "3840x2160@60";
          scale = 2;
        }
        {
          output = "desc:Dell Inc. DELL S2721DGF 6C1TR83";
          mode = "2560x1440@143.912";
          position = "0x0";
        }
        {
          output = "desc:LG Display 0x05EF Unknown";
          mode = "2560x1440@59.998";
          scale = 1.6;
        }
        {
          output = "desc:LG Electronics LG IPS FULLHD 0x01010101";
          position = "0x0";
        }
        {
          output = "eDP-1";
          scale = 1.25;
        }
      ];

      on = [
        {
          _args = [
            "hyprland.start"
            (lua ''
              function()
                hl.exec_cmd("mako")
                hl.exec_cmd("waybar-session")
              end
            '')
          ];
        }
      ];

      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
      ];

      bind = [
        (bind "SUPER + Return" (exec "ghostty"))
        (bind "SUPER + X" (exec "ghostty"))
        (bind "SUPER + E" launcher)
        (bind "SUPER + SPACE" launcher)
        (bind "SUPER + Z" (exec "zen-twilight"))
        (bind "SUPER + B" (exec "chromium"))
        (bind "SUPER + S" (exec "steam"))
        (bind "SUPER + SHIFT + S" (exec "chromium --app=https://covertone.homelab.${domain}"))
        (bind "SUPER + T" (exec "soffice"))
        (bind "SUPER + D" (exec "feishin"))
        (bind "SUPER + N" (exec "keepassxc"))
        (bind "SUPER + Y" (exec "nextcloud"))

        (bind "SUPER + SHIFT + C" (exec "hyprlock"))
        (bind "SUPER + SHIFT + P" (dsp "submap" "poweroff"))
        (bind "SUPER + SHIFT + E" (lua "hl.dsp.exit()"))

        (bind "SUPER + Q" (lua "hl.dsp.window.close()"))
        (bind "SUPER + V" (dsp "window.float" { action = "toggle"; }))
        (bind "SUPER + F" (dsp "window.fullscreen" { mode = "maximized"; }))
        (bind "SUPER + SHIFT + F" (dsp "window.fullscreen" { mode = "fullscreen"; }))
        (bind "SUPER + W" (lua "hl.dsp.group.toggle()"))
        (bind "SUPER + SHIFT + W" (lua "hl.dsp.group.next()"))
        (bind "SUPER + R" (lua "hl.dsp.window.pseudo()"))
        (bind "SUPER + C" (lua "hl.dsp.window.center()"))
        (bind "SUPER + M" (dsp "window.pin" { action = "toggle"; }))
        (bind "SUPER + BracketLeft" (lua "hl.dsp.window.swap({ direction = \"left\" })"))
        (bind "SUPER + BracketRight" (lua "hl.dsp.window.swap({ direction = \"right\" })"))

        (bind "SUPER + H" (focusDir "left"))
        (bind "SUPER + L" (focusDir "right"))
        (bind "SUPER + K" (focusDir "up"))
        (bind "SUPER + J" (focusDir "down"))
        (bind "SUPER + Left" (focusDir "left"))
        (bind "SUPER + Right" (focusDir "right"))
        (bind "SUPER + Up" (focusDir "up"))
        (bind "SUPER + Down" (focusDir "down"))

        (bind "SUPER + SHIFT + H" (moveDir "left"))
        (bind "SUPER + SHIFT + L" (moveDir "right"))
        (bind "SUPER + SHIFT + K" (moveDir "up"))
        (bind "SUPER + SHIFT + J" (moveDir "down"))
        (bind "SUPER + SHIFT + Left" (moveDir "left"))
        (bind "SUPER + SHIFT + Right" (moveDir "right"))
        (bind "SUPER + SHIFT + Up" (moveDir "up"))
        (bind "SUPER + SHIFT + Down" (moveDir "down"))

        (bind "SUPER + 1" (focusWorkspace 1))
        (bind "SUPER + 2" (focusWorkspace 2))
        (bind "SUPER + 3" (focusWorkspace 3))
        (bind "SUPER + 4" (focusWorkspace 4))
        (bind "SUPER + 5" (focusWorkspace 5))
        (bind "SUPER + 6" (focusWorkspace 6))
        (bind "SUPER + 7" (focusWorkspace 7))
        (bind "SUPER + 8" (focusWorkspace 8))
        (bind "SUPER + 9" (focusWorkspace 9))
        (bind "SUPER + SHIFT + 1" (moveToWorkspace 1))
        (bind "SUPER + SHIFT + 2" (moveToWorkspace 2))
        (bind "SUPER + SHIFT + 3" (moveToWorkspace 3))
        (bind "SUPER + SHIFT + 4" (moveToWorkspace 4))
        (bind "SUPER + SHIFT + 5" (moveToWorkspace 5))
        (bind "SUPER + SHIFT + 6" (moveToWorkspace 6))
        (bind "SUPER + SHIFT + 7" (moveToWorkspace 7))
        (bind "SUPER + SHIFT + 8" (moveToWorkspace 8))
        (bind "SUPER + SHIFT + 9" (moveToWorkspace 9))
        (bind "SUPER + I" (focusWorkspace "e-1"))
        (bind "SUPER + U" (focusWorkspace "e+1"))
        (bind "SUPER + SHIFT + I" (moveToWorkspace "e-1"))
        (bind "SUPER + SHIFT + U" (moveToWorkspace "e+1"))
        (bind "SUPER + mouse_up" (focusWorkspace "e-1"))
        (bind "SUPER + mouse_down" (focusWorkspace "e+1"))

        (bind "SUPER + TAB" (dsp "workspace.toggle_special" "scratchpad"))
        (bind "SUPER + SHIFT + TAB" (moveToWorkspace "special:scratchpad"))

        (bindWith "SUPER + mouse:272" (lua "hl.dsp.window.drag()") { mouse = true; })
        (bindWith "SUPER + mouse:273" (lua "hl.dsp.window.resize()") { mouse = true; })

        (media "XF86AudioRaiseVolume" "${helpers.volumePamixer} up")
        (media "SHIFT + XF86AudioRaiseVolume" "${helpers.volumePamixer} bigup")
        (media "XF86AudioLowerVolume" "${helpers.volumePamixer} down")
        (media "SHIFT + XF86AudioLowerVolume" "${helpers.volumePamixer} bigdown")
        (media "XF86AudioMute" "${helpers.volumePamixer} mute")
        (media "XF86MonBrightnessUp" "${helpers.brightness} +5%")
        (media "XF86MonBrightnessDown" "${helpers.brightness} 5%-")
        (media "SHIFT + XF86MonBrightnessUp" "${helpers.brightness} +10%")
        (media "SHIFT + XF86MonBrightnessDown" "${helpers.brightness} 10%-")
        (bindWith "XF86Display" (exec "${helpers.toggleGammastep}") { locked = true; })
        (bindWith "XF86Screensaver" (exec "hyprlock") { locked = true; })

        (bind "Print" (exec (screenshot "")))
        (bind "SHIFT + Print" (exec (screenshot ''-g "$(slurp -d)"'')))
      ];

      window_rule =
        let
          floatRule =
            name: match: extra:
            {
              inherit name match;
              float = true;
            }
            // extra;
        in
        [
          (floatRule "pip" { title = "^Picture-in-Picture$"; } {
            pin = true;
            size = "monitor_w/4 monitor_h/4";
            move = "monitor_w-window_w-20 20";
            opaque = true;
            no_initial_focus = true;
          })
          (floatRule "mpv" { class = "^(mpv)$"; } { opaque = true; })
          (floatRule "swayimg" { class = "^(swayimg)$"; } { })
          (floatRule "showmethekey"
            {
              class = "^(one\\.alynx\\.showmethekey)$";
              title = "^(Floating Window - Show Me The Key)$";
            }
            {
              size = "monitor_w*0.6 120";
              move = "monitor_w/2-window_w/2 monitor_h-window_h-72";
              opacity = "0.7 0.7";
              no_initial_focus = true;
            }
          )
          (floatRule "imv" { class = "^(imv)$"; } { })
          (floatRule "keepassxc" { class = "^(org\\.keepassxc\\.KeePassXC)$"; } { })
          (floatRule "zoom" { class = "^(zoom)$"; } { })
          (floatRule "steam-friends" { title = "^(Friends List)$"; } { })
          (floatRule "steam-settings" { title = "^(Steam Settings)$"; } { })
          (floatRule "ghostty-mpd-picker" { class = "^(com\\.ghostty\\.mpd-picker)$"; } { })
          (floatRule "ghostty-real-book-picker" { class = "^(com\\.ghostty\\.real-book-picker)$"; } { })
          (floatRule "file-chooser-ouvrir" { title = "^(Ouvrir)(.*)$"; } { })
          (floatRule "file-chooser-ouvrir-en" { title = "^(Open)(.*)$"; } { })
          (floatRule "file-chooser-enregistrer" { title = "^(Enregistrer)(.*)$"; } { })
          (floatRule "file-chooser-extension" { title = "^(Extension)(.*)$"; } { })
          (floatRule "file-chooser-add" { title = "^(Add)(.*)$"; } { })
          (floatRule "jetbrains-settings" { title = "^(Settings)$"; } { })
          {
            name = "suppress-maximize";
            match = {
              class = ".*";
            };
            suppress_event = "maximize";
          }
        ];
    };

    submaps = {
      resize.settings = {
        bind = [
          (bind "H" (
            dsp "window.resize" {
              x = -50;
              y = 0;
              relative = true;
            }
          ))
          (bind "L" (
            dsp "window.resize" {
              x = 50;
              y = 0;
              relative = true;
            }
          ))
          (bind "K" (
            dsp "window.resize" {
              x = 0;
              y = -50;
              relative = true;
            }
          ))
          (bind "J" (
            dsp "window.resize" {
              x = 0;
              y = 50;
              relative = true;
            }
          ))
          (bind "Left" (
            dsp "window.resize" {
              x = -50;
              y = 0;
              relative = true;
            }
          ))
          (bind "Right" (
            dsp "window.resize" {
              x = 50;
              y = 0;
              relative = true;
            }
          ))
          (bind "Up" (
            dsp "window.resize" {
              x = 0;
              y = -50;
              relative = true;
            }
          ))
          (bind "Down" (
            dsp "window.resize" {
              x = 0;
              y = 50;
              relative = true;
            }
          ))
          (bind "Escape" (dsp "submap" "reset"))
          (bind "Q" (dsp "submap" "reset"))
        ];
      };

      poweroff.settings = {
        bind = [
          (bind "P" (exec "poweroff"))
          (bind "R" (exec "reboot"))
          (bind "S" (exec "systemctl suspend"))
          (bind "L" (exec "hyprlock"))
          (bind "M" (lua "hl.dsp.exit()"))
          (bind "Escape" (dsp "submap" "reset"))
          (bind "Q" (dsp "submap" "reset"))
        ];
      };
    };
  };
}
