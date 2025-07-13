{ config, lib, pkgs, user, ... }:
let
  cfg = config.my.homelab;

  mkService = { name, image, port, volumes ? [] }:
    lib.optionalAttrs cfg.${name}.enable {
      inherit image;
      restart = "unless-stopped";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Paris";
      };
      inherit volumes;
      labels = [
        "traefik.enable=true"
        "traefik.http.routers.${name}.rule=Host(`${name}.homelab.home`)"
        "traefik.http.services.${name}.loadbalancer.server.port=${toString port}"
      ];
    };

  services = lib.foldl' lib.recursiveUpdate { } [
    (mkService { name = "lidarr"; image = "lscr.io/linuxserver/lidarr"; port = 8686; })
    (mkService { name = "radarr"; image = "lscr.io/linuxserver/radarr"; port = 7878; })
    (mkService { name = "sonarr"; image = "lscr.io/linuxserver/sonarr"; port = 8989; })
    (mkService { name = "qbittorrent"; image = "lscr.io/linuxserver/qbittorrent"; port = 8080; })
    (mkService { name = "navidrome"; image = "deluan/navidrome"; port = 4533; })
    (mkService { name = "adguardhome"; image = "adguard/adguardhome"; port = 3000; })
    (mkService { name = "paperless"; image = "ghcr.io/paperless-ngx/paperless-ngx"; port = 8000; })
    (mkService { name = "nextcloud"; image = "nextcloud"; port = 8081; })
    (mkService { name = "homeassistant"; image = "ghcr.io/home-assistant/home-assistant"; port = 8123; })
    (mkService { name = "filebrowser"; image = "filebrowser/filebrowser"; port = 8082; })
    (mkService { name = "freshrss"; image = "lscr.io/linuxserver/freshrss"; port = 8085; })
    (mkService { name = "jellyfin"; image = "lscr.io/linuxserver/jellyfin"; port = 8096; })
    (mkService { name = "librespeed"; image = "lscr.io/linuxserver/librespeed"; port = 8084; })
    (mkService { name = "slskd"; image = "ghcr.io/slskd/slskd"; port = 5030; })
  ];

  composeFile = pkgs.writeText "docker-compose.yml" (lib.generators.toYAML {} {
    version = "3";
    services = services;
  });

in
{
  options.my.homelab = {
    lidarr.enable = lib.mkEnableOption "Lidarr";
    radarr.enable = lib.mkEnableOption "Radarr";
    sonarr.enable = lib.mkEnableOption "Sonarr";
    qbittorrent.enable = lib.mkEnableOption "qBittorrent";
    navidrome.enable = lib.mkEnableOption "Navidrome";
    adguardhome.enable = lib.mkEnableOption "AdGuard Home";
    paperless.enable = lib.mkEnableOption "Paperless";
    nextcloud.enable = lib.mkEnableOption "Nextcloud";
    homeassistant.enable = lib.mkEnableOption "Home Assistant";
    filebrowser.enable = lib.mkEnableOption "File Browser";
    freshrss.enable = lib.mkEnableOption "FreshRSS";
    jellyfin.enable = lib.mkEnableOption "Jellyfin";
    librespeed.enable = lib.mkEnableOption "LibreSpeed";
    slskd.enable = lib.mkEnableOption "slskd";
  };

  config = {
    networking.domain = "home";
    environment.etc."homelab/docker-compose.yml".source = composeFile;

    systemd.services.homelab-compose = {
      description = "Start homelab docker compose";
      after = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = "/etc/homelab";
        ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/homelab/docker-compose.yml up -d";
        ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/homelab/docker-compose.yml down";
        RemainAfterExit = true;
      };
    };

    services.traefik = {
      enable = true;
      staticConfigOptions = {
        entryPoints.web.address = ":80";
        providers.docker = {
          endpoint = "unix:///var/run/docker.sock";
          exposedByDefault = false;
        };
      };
    };

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.PermitRootLogin = "yes";
    };

    users.users.${user}.openssh.authorizedKeys.keyFiles = [
      (pkgs.fetchurl {
        url = "https://github.com/dbeley.keys";
        sha256 = "vuTotxRNVwGQjv64k8dKiM5Nz/iA0q+SkhA7CKVJQQw=";
      })
    ];

    my.homelab = {
      lidarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      qbittorrent.enable = true;
      navidrome.enable = true;
      adguardhome.enable = true;
      paperless.enable = true;
      nextcloud.enable = true;
      homeassistant.enable = true;
      filebrowser.enable = true;
      freshrss.enable = true;
      jellyfin.enable = true;
      librespeed.enable = true;
      slskd.enable = true;
    };
  };
}
