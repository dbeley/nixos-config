{
  user,
  domain,
  ...
}:
let
  nfsServer = "omv.home";
  nfsExport = "/";
  nfsMount = "/mnt/nfs/root";
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

  services.jellyfin = {
    enable = true;
    inherit user;
    group = "users";
  };

  systemd = {
    services.jellyfin = {
      requires = [ "mnt-nfs-root.mount" ];
      after = [
        "mnt-nfs-root.mount"
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
