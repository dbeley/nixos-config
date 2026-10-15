{
  config,
  domain,
  lib,
  user,
  ...
}:
let
  bookorbitHost = "bookorbit.${domain}";
  appPort = 3000;
  pgPort = 5432;
  pgUser = "bookorbit";
  pgDb = "bookorbit";
  bookorbitEnvFile = config.sops.secrets."bookorbit_env".path;
  dataDir = "/var/lib/bookorbit";
  pgDataDir = "${dataDir}/postgres";
  booksDir = "/mnt/nfs/WDC14_2/Books";
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
        bookorbit-postgres = {
          image = "pgvector/pgvector:pg18";
          autoStart = true;
          ports = [ "127.0.0.1:${toString pgPort}:5432" ];
          volumes = [ "${pgDataDir}:/var/lib/postgresql/data" ];
          environment = {
            inherit TZ;
            POSTGRES_USER = pgUser;
            POSTGRES_DB = pgDb;
            PGDATA = "/var/lib/postgresql/data/pgdata";
          };
          environmentFiles = [ bookorbitEnvFile ];
          extraOptions = [ "--pull=newer" ];
        };

        bookorbit-app = {
          image = "ghcr.io/bookorbit/bookorbit:latest";
          autoStart = true;
          ports = [ "127.0.0.1:${toString appPort}:3000" ];
          volumes = [
            "${booksDir}:/books"
            "${dataDir}/app:/data"
          ];
          environment = {
            inherit TZ;
            NODE_ENV = "production";
            PORT = toString appPort;
            POSTGRES_HOST = "127.0.0.1";
            POSTGRES_PORT = toString pgPort;
            POSTGRES_USER = pgUser;
            POSTGRES_DB = pgDb;
            APP_URL = "https://${bookorbitHost}";
            LIBRARY_BROWSE_ROOT = "/books";
          };
          environmentFiles = [ bookorbitEnvFile ];
          extraOptions = [
            "--pull=newer"
            "--network=host"
          ];
        };
      };
    };
  };

  systemd.services = {
    "podman-bookorbit-postgres" = {
      after = [ "sops-nix.service" ];
      requires = lib.mkIf config.sops.useSystemdActivation [ "sops-install-secrets.service" ];
    };
    "podman-bookorbit-app" = {
      after = [
        "podman-bookorbit-postgres.service"
        "sops-nix.service"
        "mnt-nfs.mount"
      ];
      requires = [
        "podman-bookorbit-postgres.service"
        "mnt-nfs.mount"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 root root -"
    "d ${pgDataDir} 0755 root root -"
    "d ${dataDir}/app 0755 ${user} media -"
  ];

  services.nginx = {
    enable = true;
    virtualHosts.${bookorbitHost} = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString appPort}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  sops.secrets."bookorbit_env".sopsFile = ../../secrets/nixflix.yaml;
}
