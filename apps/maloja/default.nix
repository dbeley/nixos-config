{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.maloja.nixosModules.maloja ];

  services.maloja = {
    enable = true;
    host = "127.0.0.1";
    settings = {
      theme = "dark";
      location_timezone = "Europe/Paris";
    };
    environment = {
      MALOJA_SKIP_SETUP = "yes";
      MALOJA_DATA_DIRECTORY = "var/lib/maloja";
      MALOJA_SEND_STATS = "false";
      MALOJA_SCROBBLE_LASTFM = "false";
    };
    environmentFile = config.sops.secrets."maloja-env".path;
  };

  sops.secrets."maloja-env" = { };

  services.nginx.virtualHosts."maloja.home" = {
    locations."/".proxyPass = "http://localhost:42010";
    locations."/".proxyWebsockets = true;
  };
}
