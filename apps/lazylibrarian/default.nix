{
  config,
  user,
  ...
}:
let
  lazylibrarianHost = "lazylibrarian.home";
  lazylibrarianPort = 5299;
  nfsMount = "/mnt/nfs/WDC14_2";
  configDir = "/var/lib/lazylibrarian/config";
  uid =
    let
      u = config.users.users.${user}.uid or null;
    in
    if u == null then "1000" else toString u;
  mediaGid =
    let
      g = config.users.groups.media.gid or null;
    in
    if g == null then "169" else toString g;
in
{
  virtualisation = {
    podman.enable = true;
    oci-containers.containers.lazylibrarian = {
      image = "lscr.io/linuxserver/lazylibrarian:latest";
      autoStart = true;
      ports = [ "127.0.0.1:${toString lazylibrarianPort}:5299" ];
      volumes = [
        "${configDir}:/config"
        "${nfsMount}/Downloads/lazylibrarian:/downloads"
        "${nfsMount}/Books:/books"
        "${nfsMount}/Magazines:/magazines"
      ];
      environment = {
        TZ = "Europe/Paris";
        PUID = toString uid;
        PGID = toString mediaGid;
      };
      extraOptions = [ "--pull=newer" ];
    };
  };

  systemd.services."podman-lazylibrarian" = {
    requires = [ "mnt-nfs-WDC14_2.mount" ];
    after = [
      "mnt-nfs-WDC14_2.mount"
      "network-online.target"
    ];
  };

  systemd.tmpfiles.rules = [
    "d ${configDir} 0775 root root -"
  ];

  services.nginx = {
    enable = true;
    virtualHosts.${lazylibrarianHost} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString lazylibrarianPort}";
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
