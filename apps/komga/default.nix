{
  user,
  lib,
  domain,
  ...
}:
let
  komgaHost = "komga.${domain}";
  komgaPort = 25600;
in
{
  services.komga = {
    enable = true;
    inherit user;
    group = "media";
    settings.server.port = komgaPort;
  };

  systemd.services.komga = {
    requires = [ "mnt-nfs-WDC14_2.mount" ];
    after = [
      "mnt-nfs-WDC14_2.mount"
      "network-online.target"
    ];
    serviceConfig = {
      PrivateUsers = lib.mkForce false;
      UMask = "0027";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts.${komgaHost} = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString komgaPort}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 500m;
          proxy_buffering off;
          proxy_cache off;
          chunked_transfer_encoding on;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
