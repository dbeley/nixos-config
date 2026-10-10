{
  user,
  domain,
  ...
}:
{
  services.jellyfin = {
    enable = true;
    inherit user;
    group = "users";
  };

  systemd = {
    services.jellyfin = {
      requires = [ "mnt-nfs.mount" ];
      after = [
        "mnt-nfs.mount"
        "network-online.target"
      ];
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."jellyfin.${domain}" = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:8096";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
