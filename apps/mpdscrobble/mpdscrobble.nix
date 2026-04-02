{ pkgs, ... }:
let
  mpdscrobble = pkgs.python3.pkgs.callPackage ./package.nix { };
in
{
  home.packages = [ mpdscrobble ];
  systemd.user.services."mpdscrobble" = {
    Unit = {
      Description = "A simple last.fm scrobbler for MPD";
      After = "mpd.service";
      ConditionPathExists = "%h/.config/mpdscrobble/mpdscrobble.conf";
    };
    Service = {
      Type = "simple";
      ExecStart = "${mpdscrobble}/bin/mpdscrobble";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
