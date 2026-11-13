{
  config,
  lib,
  pkgs,
  ...
}:
let
  helpers = import ../../apps/scripts/scripts.nix { inherit pkgs; };
  volume = helpers.volumePamixer;
in
{
  imports = [ ../../apps/foot/foot.nix ];

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
          scale = 2;
          transform = "90";
        };
      }
    ];

    binds = {
      "Mod+Return".spawn = lib.mkForce [ "foot" ];
      "Mod+X".spawn = lib.mkForce [ "foot" ];

      "Mod+F1".spawn = [
        "${helpers.brightness}"
        "1%-"
      ];
      "Mod+Shift+F1".spawn = [
        "${helpers.brightness}"
        "10%-"
      ];
      "Mod+F2".spawn = [
        "${helpers.brightness}"
        "+1%"
      ];
      "Mod+Shift+F2".spawn = [
        "${helpers.brightness}"
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
