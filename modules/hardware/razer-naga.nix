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
      settings.main = {
        leftmouse = "rightmouse";
        rightmouse = "leftmouse";
        "1" = "home";
        "2" = "up";
        "3" = "pageup";
        "4" = "left";
        "5" = "middlemouse";
        "6" = "right";
        "7" = "end";
        "8" = "down";
        "9" = "pagedown";
        "0" = "previoussong";
        minus = "playpause";
        equal = "nextsong";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    polychromatic
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
