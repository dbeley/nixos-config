{ pkgs, ... }:
let
  mpdscrobble = pkgs.python3.pkgs.callPackage ./package.nix { };
in
{
  home.packages = [ mpdscrobble ];

  systemd.user.services."mpdscrobble" = {
    Unit = {
      Description = "A simple last.fm scrobbler for MPD";
      After = [ "mpd.service" ];
    };
    Service = {
      Type = "simple";
      ExecStartPre = pkgs.writeShellScript "mpdscrobble-setup" ''
        mkdir -p ~/.config/mpdscrobble

        LASTFM_API_KEY=$(cat ~/.config/mpdscrobble/api_key 2>/dev/null || echo "")
        LASTFM_SECRET=$(cat ~/.config/mpdscrobble/secret 2>/dev/null || echo "")
        LASTFM_PASSWORD=$(cat ~/.config/mpdscrobble/password 2>/dev/null || echo "")

        cat > ~/.config/mpdscrobble/mpdscrobble.conf << EOF
        [lastfm]
        api_key = $LASTFM_API_KEY
        secret = $LASTFM_SECRET
        password = $LASTFM_PASSWORD

        [mpd]
        host = localhost
        port = 6600
        EOF

        chmod 600 %h/.config/mpdscrobble/mpdscrobble.conf
      '';
      ExecStart = "${mpdscrobble}/bin/mpdscrobble -c %h/.config/mpdscrobble/mpdscrobble.conf";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
