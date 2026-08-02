{
  user,
  ...
}:
let
  nfsServer = "omv.home";
  nfsExport = "/WDC14";
  nfsMount = "/mnt/nfs/WDC14";
  audiobookshelfHost = "audiobookshelf.home";
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

  services.audiobookshelf = {
    enable = true;
    inherit user;
    group = "users";
  };

  systemd.services.audiobookshelf = {
    requires = [ "mnt-nfs-WDC14.mount" ];
    after = [
      "mnt-nfs-WDC14.mount"
      "network-online.target"
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts.${audiobookshelfHost} = {
      locations."/" = {
        proxyPass = "http://localhost:8000";
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
