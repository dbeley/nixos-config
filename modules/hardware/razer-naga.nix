{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  # Strip the leading `#` from stylix's hex so razer-cli accepts it.
  accentHex = lib.removePrefix "#" config.lib.stylix.colors.withHashtag.base0D;
in
{
  hardware.openrazer = {
    enable = true;
    users = [ user ];
    devicesOffOnScreensaver = false;
  };

  services.keyd = {
    enable = true;
    keyboards.razer-naga = {
      # Both interfaces of the same device share state, so the left/right
      # swap and the thumb-grid remap live in one config. The `m:` prefix
      # limits the mouse binding to the pointer interface; `k:` limits the
      # thumb-grid remap to the keyboard interface — no cross-grabbing.
      ids = [
        "m:1532:008d"
        "k:1532:008d"
      ];
      settings = {
        main = {
          leftmouse = "rightmouse";
          rightmouse = "leftmouse";
          # Exclusive mode selector: 1 = main, 2 = tabs, 3 = wm.
          # toggle() enters from main (swap() is a no-op there);
          # swap() switches exclusively between the toggled layers;
          # noop makes re-pressing an already-active mode a no-op.
          "1" = "clear()";
          "2" = "toggle(tabs)";
          "3" = "toggle(wm)";
          "4" = "pageup";
          "5" = "up";
          "6" = "home";
          "7" = "left";
          "8" = "middlemouse";
          "9" = "right";
          "0" = "pagedown";
          minus = "down";
          equal = "end";
        };
        tabs = {
          "1" = "clear()";
          "2" = "noop";
          "3" = "swap(wm)";
          "4" = "C-S-tab";
          "5" = "C-w";
          "6" = "C-tab";
          "7" = "C-S-t";
          "8" = "C-r";
          "9" = "C-t";
          "0" = "A-h";
          minus = "C-s";
          equal = "A-l";
        };
        wm = {
          "1" = "clear()";
          "2" = "swap(tabs)";
          "3" = "noop";
          "4" = "M-r";
          "5" = "M-k";
          "6" = "M-f";
          "7" = "M-h";
          "8" = "M-tab";
          "9" = "M-l";
          "0" = "M-S-h";
          minus = "M-j";
          equal = "M-S-l";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # polychromatic
    razer-cli
  ];

  systemd.user.services.razer-naga-color = {
    description = "Apply stylix accent colour to Razer Naga";
    after = [ "openrazer-daemon.service" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.razer-cli}/bin/razer-cli -c ${accentHex} -b 10 --poll 1000 --dpi 1600";
    };
    restartTriggers = [ accentHex ];
  };
}
