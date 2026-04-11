{
  pkgs,
  user,
  ...
}:
{
  home.packages = [ pkgs.sops ];
  sops = {
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets = {
      lastfm-api-key = {
        sopsFile = ../../secrets/secrets.yaml;
        key = "lastfm_api_key";
        path = "/home/${user}/.config/mpdscrobble/api_key";
      };
      lastfm-secret = {
        sopsFile = ../../secrets/secrets.yaml;
        key = "lastfm_secret";
        path = "/home/${user}/.config/mpdscrobble/secret";
      };
      lastfm-password = {
        sopsFile = ../../secrets/secrets.yaml;
        key = "lastfm_password";
        path = "/home/${user}/.config/mpdscrobble/password";
      };
      restic-password = {
        sopsFile = ../../secrets/secrets.yaml;
        key = "restic_password";
        path = "/home/${user}/.config/restic/password";
      };
    };
  };
}
