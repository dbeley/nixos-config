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
      settings = {
        http.address = "127.0.0.1:3000";

        dns = {
          upstream_dns = [
            "tls://ns0.fdn.fr"
            "tls://ns1.fdn.fr"
          ];
          bootstrap_dns = [
            "1.1.1.1"
            "1.0.0.1"
            "8.8.8.8"
          ];
          upstream_mode = "parallel";
        };
      };
    };

    nginx = {
      enable = true;
      virtualHosts.${adguardHost} = {
        useACMEHost = domain;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:3000";
      };
    };

    resolved.enable = lib.mkForce false;
  };

  networking = {
    firewall = {
      allowedTCPPorts = [
        53
        80
        443
      ];
      allowedUDPPorts = [ 53 ];
    };
    tempAddresses = "disabled";
  };
}
