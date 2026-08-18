{
  config,
  lib,
  domain,
  ...
}:
let
  audiomuseHost = "audiomuse.${domain}";
  audiomusePort = 8000;
  pgPort = 5432;
  pgUser = "audiomuse";
  pgDb = "audiomusedb";
  pgPasswordFile = config.sops.secrets."audiomuse-pg-password".path;
  dataDir = "/var/lib/audiomuse-ai";
  tempDir = "${dataDir}/temp_audio";
  pgDataDir = "${dataDir}/postgres";
  pluginsDir = "${dataDir}/plugins";
  TZ = "Europe/Paris";
in
{
  virtualisation = {
    podman.enable = true;
    containers.registries.settings = {
      unqualified-search-registries = [
        "docker.io"
        "quay.io"
      ];
      registry = [
        { location = "docker.io"; }
        { location = "quay.io"; }
      ];
    };
    oci-containers = {
      backend = "podman";
      containers = {
        audiomuse-postgres = {
          image = "postgres:15-alpine";
          autoStart = true;
          ports = [ "127.0.0.1:${toString pgPort}:5432" ];
          volumes = [ "${pgDataDir}:/var/lib/postgresql/data" ];
          environment = {
            inherit TZ;
            POSTGRES_USER = pgUser;
            POSTGRES_DB = pgDb;
          };
          environmentFiles = [ pgPasswordFile ];
          extraOptions = [ "--pull=newer" ];
        };

        audiomuse-flask = {
          image = "ghcr.io/neptunehub/audiomuse-ai:3.2.0";
          autoStart = true;
          ports = [ "127.0.0.1:${toString audiomusePort}:8000" ];
          volumes = [
            "${tempDir}:/app/temp_audio"
            "${pluginsDir}:/app/plugin/installed"
          ];
          environment = {
            inherit TZ;
            SERVICE_TYPE = "flask";
            POSTGRES_USER = pgUser;
            POSTGRES_DB = pgDb;
            POSTGRES_HOST = "127.0.0.1";
            POSTGRES_PORT = toString pgPort;
            TEMP_DIR = "/app/temp_audio";
          };
          environmentFiles = [ pgPasswordFile ];
          extraOptions = [
            "--pull=newer"
            "--network=host"
          ];
        };

        audiomuse-worker = {
          image = "ghcr.io/neptunehub/audiomuse-ai:3.2.0";
          autoStart = true;
          volumes = [
            "${tempDir}:/app/temp_audio"
            "${pluginsDir}:/app/plugin/installed"
          ];
          environment = {
            inherit TZ;
            SERVICE_TYPE = "worker";
            POSTGRES_USER = pgUser;
            POSTGRES_DB = pgDb;
            POSTGRES_HOST = "127.0.0.1";
            POSTGRES_PORT = toString pgPort;
            TEMP_DIR = "/app/temp_audio";
          };
          environmentFiles = [ pgPasswordFile ];
          extraOptions = [
            "--pull=newer"
            "--network=host"
          ];
        };
      };
    };
  };

  systemd.services = {
    "podman-audiomuse-postgres" = {
      after = [ "sops-nix.service" ];
      requires = lib.mkIf config.sops.useSystemdActivation [ "sops-install-secrets.service" ];
    };
    "podman-audiomuse-flask" = {
      after = [
        "podman-audiomuse-postgres.service"
        "sops-nix.service"
      ];
      requires = [ "podman-audiomuse-postgres.service" ];
    };
    "podman-audiomuse-worker" = {
      after = [
        "podman-audiomuse-postgres.service"
        "sops-nix.service"
      ];
      requires = [ "podman-audiomuse-postgres.service" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 root root -"
    "d ${pgDataDir} 0755 root root -"
    "d ${tempDir} 0755 root root -"
    "d ${pluginsDir} 0755 root root -"
  ];

  sops.secrets."audiomuse-pg-password" = {
    sopsFile = ../../secrets/music.yaml;
  };

  services.nginx = {
    enable = true;
    virtualHosts.${audiomuseHost} = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString audiomusePort}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
