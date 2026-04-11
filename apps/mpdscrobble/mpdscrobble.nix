{ pkgs, ... }:
let
  mpdscrobble = pkgs.python3.pkgs.callPackage ./package.nix { };
in
{
  home.packages = [ mpdscrobble ];

  # Create mpdscrobble config file at activation time using sops secrets
  home.activation.createMpdscrobbleConfig = ''
    # Create mpdscrobble config directory if it doesn't exist
    mkdir -p ~/.config/mpdscrobble

    # Read API keys from sops secret files
    LASTFM_API_KEY=$(cat ~/.config/mpdscrobble/api_key 2>/dev/null || echo "")
    LASTFM_SECRET=$(cat ~/.config/mpdscrobble/secret 2>/dev/null || echo "")
    LASTFM_PASSWORD=$(cat ~/.config/mpdscrobble/password 2>/dev/null || echo "")

    # Create config file
    cat > ~/.config/mpdscrobble/mpdscrobble.conf << EOF
    [lastfm]
    api_key = $LASTFM_API_KEY
    secret = $LASTFM_SECRET
    password = $LASTFM_PASSWORD

    [mpd]
    host = localhost
    port = 6600
    EOF

    # Set proper permissions
    chmod 600 ~/.config/mpdscrobble/mpdscrobble.conf
  '';

  systemd.user.services."mpdscrobble" = {
    Unit = {
      Description = "A simple last.fm scrobbler for MPD";
      After = "mpd.service";
      ConditionPathExists = "%h/.config/mpdscrobble/mpdscrobble.conf";
    };
    Service = {
      Type = "simple";
      ExecStart = "${mpdscrobble}/bin/mpdscrobble -c %h/.config/mpdscrobble/mpdscrobble.conf";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
