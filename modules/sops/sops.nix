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
        key = "lastfm_api_key";
        path = "/home/${user}/.config/mpdscrobble/api_key";
      };
      lastfm-secret = {
        key = "lastfm_secret";
        path = "/home/${user}/.config/mpdscrobble/secret";
      };
      lastfm-password = {
        key = "lastfm_password";
        path = "/home/${user}/.config/mpdscrobble/password";
      };
      restic-password = {
        key = "restic_password";
        path = "/home/${user}/.config/restic/password";
      };
      hermes-webui-password = {
        path = "/home/${user}/.config/hermes/webui-password";
      };
    };
  };
}
