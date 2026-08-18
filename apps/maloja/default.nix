{
  config,
  inputs,
  domain,
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
    environmentFile = config.sops.secrets."maloja-env".path;
  };

  sops.secrets."maloja-env" = {
    sopsFile = ../../secrets/music.yaml;
  };

  services.nginx.virtualHosts."maloja.${domain}" = {
    useACMEHost = domain;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:42010";
    locations."/".proxyWebsockets = true;
  };
}
