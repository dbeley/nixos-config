{
  config,
  lib,
  pkgs,
  user,
  ...
}:

let
  cfg = config.services.docker-homelab;

  mkService =
    name:
    {
      image,
      port,
      subdomain,
      volumes ? [ ],
      environment ? { },
      extraLabels ? { },
      depends ? [ ],
      extraOpts ? { },
    }:
    let
      traefikLabels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${name}.rule" = "Host(`${subdomain}.${cfg.domain}`)";
        "traefik.http.routers.${name}.entrypoints" = "websecure";
        "traefik.http.routers.${name}.tls" = "true";
        "traefik.http.routers.${name}.tls.certresolver" = "letsencrypt";
        "traefik.http.services.${name}.loadbalancer.server.port" = toString port;
      };

      allLabels = traefikLabels // extraLabels;

      labelArgs = lib.flatten (
        lib.mapAttrsToList (key: value: [
          "--label"
          "${key}=${value}"
        ]) allLabels
      );

      volumeArgs = lib.flatten (
        map (v: [
          "-v"
          v
        ]) volumes
      );

      envArgs = lib.flatten (
        lib.mapAttrsToList (key: value: [
          "-e"
          "${key}=${value}"
        ]) environment
      );

      networkArgs = [
        "--network"
        cfg.traefik_network
      ];

      dependsArgs = lib.flatten (
        map (dep: [
          "--depends-on"
          dep
        ]) depends
      );

      containerName = "homelab-${name}";
    in
    {
      description = "Docker Homelab: ${name}";
      wantedBy = [ "multi-user.target" ];
      after = [
        "docker.service"
        "docker-homelab-network.service"
      ]
      ++ map (dep: "homelab-${dep}.service") depends;
      requires = [
        "docker.service"
        "docker-homelab-network.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = ''
          ${pkgs.docker}/bin/docker run -d \
            --name ${containerName} \
            --restart unless-stopped \
            ${lib.concatStringsSep " \\\n            " (
              networkArgs
              ++ labelArgs
              ++ volumeArgs
              ++ envArgs
              ++ dependsArgs
              ++ (lib.mapAttrsToList (k: v: "${k} ${v}") extraOpts)
              ++ [ image ]
            )}
        '';
        ExecStop = "${pkgs.docker}/bin/docker stop -t 10 ${containerName}";
        ExecStopPost = "${pkgs.docker}/bin/docker rm -f ${containerName}";
      };
    };

  traefikService = {
    description = "Docker Homelab: Traefik Reverse Proxy";
    wantedBy = [ "multi-user.target" ];
    after = [
      "docker.service"
      "docker-homelab-network.service"
    ];
    requires = [
      "docker.service"
      "docker-homelab-network.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''
        ${pkgs.docker}/bin/docker run -d \
          --name homelab-traefik \
          --restart unless-stopped \
          --network ${cfg.traefik_network} \
          -p 80:80 \
          -p 443:443 \
          -v /var/run/docker.sock:/var/run/docker.sock:ro \
          -v ${cfg.volume_root}/traefik:/etc/traefik \
          -v ${cfg.volume_root}/traefik/acme:/etc/traefik/acme \
          --label "traefik.enable=true" \
          --label "traefik.http.routers.traefik.rule=Host(\`traefik.${cfg.domain}\`)" \
          --label "traefik.http.routers.traefik.entrypoints=websecure" \
          --label "traefik.http.routers.traefik.tls=true" \
          --label "traefik.http.routers.traefik.tls.certresolver=letsencrypt" \
          --label "traefik.http.routers.traefik.service=api@internal" \
          --label "traefik.http.services.traefik.loadbalancer.server.port=8080" \
          traefik:v3.6 \
          --api.dashboard=true \
          --api.insecure=false \
          --entrypoints.web.address=:80 \
          --entrypoints.websecure.address=:443 \
          --entrypoints.web.http.redirections.entrypoint.to=websecure \
          --entrypoints.web.http.redirections.entrypoint.scheme=https \
          --providers.docker=true \
          --providers.docker.exposedbydefault=false \
          --providers.docker.network=${cfg.traefik_network} \
          --certificatesresolvers.letsencrypt.acme.httpchallenge=true \
          --certificatesresolvers.letsencrypt.acme.httpchallenge.entrypoint=web \
          --certificatesresolvers.letsencrypt.acme.email=${cfg.letsencrypt_email} \
          --certificatesresolvers.letsencrypt.acme.storage=/etc/traefik/acme/acme.json \
          --log.level=INFO
      '';
      ExecStop = "${pkgs.docker}/bin/docker stop -t 10 homelab-traefik";
      ExecStopPost = "${pkgs.docker}/bin/docker rm -f homelab-traefik";
    };
  };

  networkService = {
    description = "Docker Homelab: Create homelab network";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.docker}/bin/docker network create ${cfg.traefik_network} 2>/dev/null || true'";
      ExecStop = "${pkgs.bash}/bin/bash -c '${pkgs.docker}/bin/docker network rm ${cfg.traefik_network} 2>/dev/null || true'";
    };
  };

  volumeDirs = lib.flatten (
    map (v: lib.optional (lib.hasPrefix cfg.volume_root v) v) (
      lib.flatten (lib.mapAttrsToList (_: svc: svc.volumes or [ ]) cfg.services)
    )
  );

  createVolumesScript = ''
    ${lib.concatStringsSep "\n" (map (dir: "mkdir -p ${dir}") (lib.unique volumeDirs))}
    chmod -R 755 ${cfg.volume_root}
  '';

  containers = {
    jellyfin = mkService "jellyfin" {
      image = "lscr.io/linuxserver/jellyfin:latest";
      port = 8096;
      subdomain = "jellyfin";
      volumes = [
        "${cfg.volume_root}/jellyfin:/config"
        "${cfg.volume_root}/jellyfin/cache:/cache"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Europe/Paris";
      };
      extraOpts = {
        "--device" = "/dev/dri:/dev/dri";
      };
    };

    sonarr = mkService "sonarr" {
      image = "lscr.io/linuxserver/sonarr:latest";
      port = 8989;
      subdomain = "sonarr";
      volumes = [
        "${cfg.volume_root}/sonarr:/config"
        "${cfg.volume_root}/downloads:/downloads"
        "${cfg.volume_root}/media/tv:/tv"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Europe/Paris";
      };
    };

    radarr = mkService "radarr" {
      image = "lscr.io/linuxserver/radarr:latest";
      port = 7878;
      subdomain = "radarr";
      volumes = [
        "${cfg.volume_root}/radarr:/config"
        "${cfg.volume_root}/downloads:/downloads"
        "${cfg.volume_root}/media/movies:/movies"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Europe/Paris";
      };
    };

    lidarr = mkService "lidarr" {
      image = "lscr.io/linuxserver/lidarr:latest";
      port = 8686;
      subdomain = "lidarr";
      volumes = [
        "${cfg.volume_root}/lidarr:/config"
        "${cfg.volume_root}/downloads:/downloads"
        "${cfg.volume_root}/media/music:/music"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Europe/Paris";
      };
    };

    bazarr = mkService "bazarr" {
      image = "lscr.io/linuxserver/bazarr:latest";
      port = 6767;
      subdomain = "bazarr";
      volumes = [
        "${cfg.volume_root}/bazarr:/config"
        "${cfg.volume_root}/media/movies:/movies"
        "${cfg.volume_root}/media/tv:/tv"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Europe/Paris";
      };
    };

    qbittorrent = mkService "qbittorrent" {
      image = "lscr.io/linuxserver/qbittorrent:latest";
      port = 8080;
      subdomain = "qbit";
      volumes = [
        "${cfg.volume_root}/qbittorrent:/config"
        "${cfg.volume_root}/downloads:/downloads"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Europe/Paris";
        WEBUI_PORT = "8080";
      };
      extraLabels = {
        "traefik.http.middlewares.qbit-auth.basicauth.users" = "";
      };
    };

    prowlarr = mkService "prowlarr" {
      image = "lscr.io/linuxserver/prowlarr:latest";
      port = 9696;
      subdomain = "prowlarr";
      volumes = [
        "${cfg.volume_root}/prowlarr:/config"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Europe/Paris";
      };
    };

    overseerr = mkService "overseerr" {
      image = "lscr.io/linuxserver/overseerr:latest";
      port = 5055;
      subdomain = "overseerr";
      volumes = [
        "${cfg.volume_root}/overseerr:/config"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Europe/Paris";
      };
    };

    tautulli = mkService "tautulli" {
      image = "lscr.io/linuxserver/tautulli:latest";
      port = 8181;
      subdomain = "tautulli";
      volumes = [
        "${cfg.volume_root}/tautulli:/config"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Europe/Paris";
      };
    };
  };
in
{
  options.services.docker-homelab = {
    enable = lib.mkEnableOption "Docker Homelab with Traefik reverse proxy";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "example.com";
      description = "Base domain for all homelab services";
    };

    traefik_network = lib.mkOption {
      type = lib.types.str;
      default = "homelab";
      description = "Docker network name for homelab containers";
    };

    volume_root = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/docker";
      description = "Root directory for persistent volume storage";
    };

    letsencrypt_email = lib.mkOption {
      type = lib.types.str;
      default = "admin@example.com";
      description = "Email address for Let's Encrypt certificate registration";
    };

    services = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            image = lib.mkOption {
              type = lib.types.str;
              description = "Docker image for the container";
            };
            port = lib.mkOption {
              type = lib.types.port;
              description = "Internal container port";
            };
            subdomain = lib.mkOption {
              type = lib.types.str;
              description = "Subdomain for Traefik routing";
            };
            volumes = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Volume mounts for the container";
            };
            environment = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              default = { };
              description = "Environment variables for the container";
            };
            extraLabels = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              default = { };
              description = "Additional Docker labels";
            };
            extraOpts = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              default = { };
              description = "Additional docker run options (key-value pairs)";
            };
          };
        }
      );
      default = { };
      description = "Custom service definitions (merged with defaults)";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    users.users.${user}.extraGroups = [ "docker" ];

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    systemd.services =
      lib.mapAttrs' (name: service: lib.nameValuePair "homelab-${name}" service) (
        containers // cfg.services
      )
      // {
        docker-homelab-volumes = {
          description = "Docker Homelab: Create volume directories";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.bash}/bin/bash -c '${createVolumesScript}'";
          };
        };

        docker-homelab-network = networkService;

        homelab-traefik = traefikService;
      };
  };
}
