{
  lib,
  domain,
  ...
}:
let
  adguardHost = "adguard.${domain}";
in
{
  services = {
    adguardhome = {
      enable = true;
      port = 3000;
      settings = { };
    };

    nginx = {
      enable = true;
      virtualHosts.${adguardHost} = {
        useACMEHost = domain;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:3000";
      };
    };

    resolved.enable = lib.mkForce false;
  };

  networking.firewall.allowedTCPPorts = [
    53
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
