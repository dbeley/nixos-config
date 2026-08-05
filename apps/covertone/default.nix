{ inputs, domain, ... }:
{
  imports = [ inputs.covertone.nixosModules.default ];

  services.covertone = {
    enable = true;
    virtualHost = "covertone.${domain}";
  };

  services.nginx.virtualHosts."covertone.${domain}" = {
    useACMEHost = domain;
    forceSSL = true;
  };
}
