{
  config,
  pkgs,
  ...
}: let
  mpdscrobble = pkgs.python3.pkgs.callPackage ./package.nix {};
in {
  home.packages = with pkgs; [mpdscrobble];
  systemd.user.services."mpdscrobble" = {
    Unit = {
      Description = "Take a screenshot with grim";
      After = "mpd.service";
    };
    Service = {
      Type = "simple";
      ExecStart = "${mpdscrobble}/bin/mpdscrobble";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
}
