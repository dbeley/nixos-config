{
  config,
  lib,
  pkgs,
  ...
}:
let
  brightness = pkgs.writeShellScript "brightness" ''
    ${pkgs.brightnessctl}/bin/brightnessctl s "$1"
    PCT=$(${pkgs.brightnessctl}/bin/brightnessctl -m | cut -d, -f4 | tr -d '%')
    ${pkgs.libnotify}/bin/notify-send -t 500 "BRI ''${PCT}%" \
      -h string:x-canonical-private-synchronous:brightness \
      -h int:value:"''${PCT}"
  '';
  volume = "${config.home.homeDirectory}/scripts/volume_pamixer.sh";
in
{
  my.niri.gpu-effects = false;

  services = {
    # Suspend-to-RAM hangs on this SoC.
    swayidle.enable = lib.mkForce false;

    gammastep.enable = lib.mkForce false;
    mpd.musicDirectory = lib.mkForce "${config.home.homeDirectory}/nfs/WDC14/Musique-Bandcamp";
  };

  programs = {
    ghostty.enable = lib.mkForce false;

    chromium.commandLineArgs = [
      "--disable-gpu"
      "--enable-low-end-device-mode"
      "--renderer-process-limit=3"
      "--process-per-site"
      "--disk-cache-size=134217728"
    ];

    foot = {
      enable = true;
      settings.main = {
        font = "Iosevka Nerd Font Mono:size=12";
        pad = "8x8";
      };
    };
  };

  wayland.windowManager.niri.settings = {
    layout = {
      gaps = lib.mkForce 8;
      struts.top = lib.mkForce 4;
      border.width = lib.mkForce 3;
      default-column-width = {
        proportion = 1.0;
      };
    };

    # Internal panel: 1200x1920 portrait-native, rotated to landscape.
    _children = [
      {
        output = {
          _args = [ "DSI-1" ];
          scale = 1.75;
          transform = "90";
        };
      }
    ];

    binds = {
      "Mod+Return".spawn = lib.mkForce [ "foot" ];
      "Mod+X".spawn = lib.mkForce [ "foot" ];

      "Mod+F1".spawn = [
        "${brightness}"
        "1%-"
      ];
      "Mod+Shift+F1".spawn = [
        "${brightness}"
        "10%-"
      ];
      "Mod+F2".spawn = [
        "${brightness}"
        "+1%"
      ];
      "Mod+Shift+F2".spawn = [
        "${brightness}"
        "+10%"
      ];
      "Mod+F3".spawn = [
        "${volume}"
        "down"
      ];
      "Mod+Shift+F3".spawn = [
        "${volume}"
        "bigdown"
      ];
      "Mod+F4".spawn = [
        "${volume}"
        "up"
      ];
      "Mod+Shift+F4".spawn = [
        "${volume}"
        "bigup"
      ];
      "Mod+F5".spawn = [
        "${volume}"
        "mute"
      ];

      "Mod+F8".spawn = lib.mkForce [
        "foot"
        "--app-id=com.ghostty.real-book-picker"
        "-e"
        "fish"
        "-c"
        "real_book_picker"
      ];
    };
  };
}
