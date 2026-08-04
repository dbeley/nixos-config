{
  domain,
  user,
  lib,
  ...
}:
let
  shelfmarkHost = "shelfmark.${domain}";
  shelfmarkPort = 8084;
  nfsMount = "/mnt/nfs/WDC14_2";
in
{
  services.shelfmark = {
    enable = true;
    environment = {
      FLASK_HOST = "127.0.0.1";
      FLASK_PORT = shelfmarkPort;
      SEARCH_MODE = "universal";
      BOOK_LANGUAGE = "fr,en";
      INGEST_DIR = "${nfsMount}/Books";
    };
  };

  systemd.services.shelfmark = {
    requires = [ "mnt-nfs-WDC14_2.mount" ];
    after = [
      "mnt-nfs-WDC14_2.mount"
      "network-online.target"
    ];
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = user;
      Group = "media";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts.${shelfmarkHost} = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString shelfmarkPort}";
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
