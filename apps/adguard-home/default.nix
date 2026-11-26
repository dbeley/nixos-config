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
        http.address = "0.0.0.0:3000";

        # Never rely on AdGuard Home's built-in defaults: they upstream to Quad9 which is blocked in France
        dns = {
          upstream_dns = [
            "https://cloudflare-dns.com/dns-query"
            "https://dns.google/dns-query"
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
        locations."/".proxyPass = "http://localhost:3000";
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
