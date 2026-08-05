{
  config,
  lib,
  user,
  domain,
  ...
}:
let
  nfsServer = "omv.home";
  nfsExport = "/WDC14_2";
  nfsMount = "/mnt/nfs/WDC14_2";
in
{
  fileSystems.${nfsMount} = {
    device = "${nfsServer}:${nfsExport}";
    fsType = "nfs";
    options = [
      "_netdev"
      "nofail"
      "hard"
      "timeo=60"
      "retrans=3"
    ];
  };

  services = {
    immich = {
      enable = true;
      host = "127.0.0.1";
      port = 2283;
      mediaLocation = "${nfsMount}/Immich";
      inherit user;
      group = "users";
      database.user = user;
      database.name = user;
      environment.DB_URL = lib.mkForce "postgresql://${config.services.immich.database.user}@localhost/${config.services.immich.database.name}?host=${config.services.immich.database.host}";
    };

    postgresql.ensureUsers = lib.mkForce [
      {
        name = config.services.immich.database.user;
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
          superuser = true;
        };
      }
    ];

    nginx = {
      enable = true;
      virtualHosts."immich.${domain}" = {
        useACMEHost = domain;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };
    };
  };

  systemd.services.immich-server = {
    requires = [ "mnt-nfs-WDC14_2.mount" ];
    wants = [ "network-online.target" ];
    after = [
      "mnt-nfs-WDC14_2.mount"
      "network-online.target"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
