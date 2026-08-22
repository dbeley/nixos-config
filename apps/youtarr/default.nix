{
  config,
  domain,
  lib,
  user,
  ...
}:
let
  youtarrHost = "youtarr.${domain}";
  youtarrData = "/var/lib/youtarr";
  youtarrVideos = "/mnt/nfs/WDC14_2/Youtarr";
  youtarrEnv = config.sops.secrets."youtarr-env".path;
  youtarrUid = 1000;
  mediaGid = 169;
in
{
  virtualisation = {
    podman.enable = true;
    oci-containers = {
      backend = "podman";
      containers = {
        youtarr-db = {
          image = "docker.io/library/mariadb:10.3";
          autoStart = true;
          volumes = [ "${youtarrData}/database:/var/lib/mysql" ];
          environment = {
            MYSQL_DATABASE = "youtarr";
            MYSQL_USER = "youtarr";
            MYSQL_TCP_PORT = "3321";
          };
          environmentFiles = [ youtarrEnv ];
          extraOptions = [
            "--network=host"
            "--pull=newer"
          ];
          cmd = [
            "--port=3321"
            "--bind-address=127.0.0.1"
            "--character-set-server=utf8mb4"
            "--collation-server=utf8mb4_unicode_ci"
            "--innodb-file-per-table=1"
            "--innodb-large-prefix=ON"
          ];
        };

        youtarr = {
          image = "docker.io/dialmaster/youtarr:v1.79.0";
          autoStart = true;
          user = "${toString youtarrUid}:${toString mediaGid}";
          volumes = [
            "${youtarrVideos}:/usr/src/app/data"
            "${youtarrData}/config:/app/config"
            "${youtarrData}/jobs:/app/jobs"
            "${youtarrData}/images:/app/server/images"
          ];
          environment = {
            IN_DOCKER_CONTAINER = "1";
            TZ = "Europe/Paris";
            DB_HOST = "127.0.0.1";
            DB_PORT = "3321";
            DB_USER = "youtarr";
            DB_NAME = "youtarr";
            YOUTUBE_OUTPUT_DIR = "/usr/src/app/data";
          };
          environmentFiles = [ youtarrEnv ];
          extraOptions = [
            "--network=host"
            "--pull=newer"
          ];
        };
      };
    };
  };

  systemd.services = {
    "podman-youtarr-db" = {
      after = [ "sops-nix.service" ];
      requires = lib.mkIf config.sops.useSystemdActivation [ "sops-install-secrets.service" ];
    };
    "podman-youtarr" = {
      after = [
        "podman-youtarr-db.service"
        "sops-nix.service"
        "mnt-nfs-WDC14_2.mount"
      ];
      requires = [
        "podman-youtarr-db.service"
        "mnt-nfs-WDC14_2.mount"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d ${youtarrData} 0755 root root -"
    "d ${youtarrData}/database 0755 root root -"
    "d ${youtarrData}/config 0775 ${user} media -"
    "d ${youtarrData}/jobs 0775 ${user} media -"
    "d ${youtarrData}/images 0775 ${user} media -"
    "d ${youtarrVideos} 0775 ${user} media -"
  ];

  sops.secrets."youtarr-env" = {
    sopsFile = ../../secrets/nixflix.yaml;
  };

  services.nginx.virtualHosts.${youtarrHost} = {
    useACMEHost = domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3011";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
