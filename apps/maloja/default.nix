{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.maloja.nixosModules.maloja ];

  sops.secrets."maloja-env" = { };

  services.maloja = {
    enable = true;
    host = "127.0.0.1";
    settings = {
      theme = "dark";
      location_timezone = "Europe/Berlin";
    };
    environmentFile = config.sops.secrets."maloja-env".path;
  };

  services.nginx.virtualHosts."maloja.navidrome.home" = {
    locations."/".proxyPass = "http://localhost:42010";
    locations."/".proxyWebsockets = true;
  };
}
