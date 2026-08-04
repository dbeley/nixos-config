{
  config,
  user,
  ...
}:
let
  mylarHost = "mylar.home";
  mylarPort = 8090;
  nfsMount = "/mnt/nfs/WDC14_2";
  configDir = "/var/lib/mylar/config";
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
    oci-containers.containers.mylar = {
      image = "lscr.io/linuxserver/mylar3:latest";
      autoStart = true;
      ports = [ "127.0.0.1:${toString mylarPort}:8090" ];
      volumes = [
        "${configDir}:/config"
        "${nfsMount}/Downloads/mylar:/downloads"
        "${nfsMount}/Comics:/comics"
      ];
      environment = {
        TZ = "Europe/Paris";
        PUID = toString uid;
        PGID = toString mediaGid;
      };
      extraOptions = [ "--pull=newer" ];
    };
  };

  systemd.services."podman-mylar" = {
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
    virtualHosts.${mylarHost} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString mylarPort}";
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
