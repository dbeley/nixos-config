_:
let
  shelfmarkHost = "shelfmark.home";
  shelfmarkPort = 8084;
in
{
  services.shelfmark = {
    enable = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts.${shelfmarkHost} = {
      locations."/" = {
        proxyPass = "http://localhost:${toString shelfmarkPort}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = "client_max_body_size 500m;";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
