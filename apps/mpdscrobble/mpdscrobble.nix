{ pkgs, config, ... }:
let
  mpdscrobble = pkgs.python3.pkgs.callPackage ./package.nix { };
in
{
  home.packages = [ mpdscrobble ];

  sops.secrets = {
    lastfm-username.key = "lastfm_username";
    lastfm-api-key.key = "lastfm_api_key";
    lastfm-secret.key = "lastfm_secret";
    lastfm-password.key = "lastfm_password";
  };

  # api_key/api_secret only identify the application, scrobbling also needs the
  # user credentials. The rendered file lives in /run (0400), not in $HOME.
  sops.templates."mpdscrobble.conf" = {
    path = "${config.home.homeDirectory}/.config/mpdscrobble/mpdscrobble.conf";
    mode = "0400";
    content = ''
      [mpdscrobble]
      host = localhost
      port = 6600

      [last.fm]
      username = ${config.sops.placeholder.lastfm-username}
      password = ${config.sops.placeholder.lastfm-password}
      api_key = ${config.sops.placeholder.lastfm-api-key}
      api_secret = ${config.sops.placeholder.lastfm-secret}
    '';
  };

  systemd.user.services."mpdscrobble" = {
    Unit = {
      Description = "A simple last.fm scrobbler for MPD";
      After = [ "mpd.service" ];
      Wants = [ "mpd.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${mpdscrobble}/bin/mpdscrobble -c %h/.config/mpdscrobble/mpdscrobble.conf";
      Restart = "on-failure";
      RestartSec = 30;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
