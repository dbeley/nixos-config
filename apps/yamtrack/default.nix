{
  config,
  lib,
  domain,
  ...
}:
let
  yamtrackHost = "yamtrack.${domain}";
  dataDir = "/var/lib/yamtrack";
  TZ = "Europe/Paris";
in
{
  virtualisation = {
    podman.enable = true;
    oci-containers = {
      backend = "podman";
      containers = {
        yamtrack-redis = {
          image = "redis:8-alpine";
          autoStart = true;
          ports = [ "127.0.0.1:6379:6379" ];
          volumes = [ "${dataDir}/redis-data:/data" ];
          extraOptions = [ "--pull=newer" ];
        };

        yamtrack = {
          image = "ghcr.io/fuzzygrim/yamtrack";
          autoStart = true;
          ports = [ "127.0.0.1:8000:8000" ];
          volumes = [ "${dataDir}/db:/yamtrack/db" ];
          environment = { inherit TZ; };
          environmentFiles = [ config.sops.secrets."yamtrack_env".path ];
          extraOptions = [
            "--pull=newer"
            "--network=host"
          ];
        };
      };
    };
  };

  systemd.services = {
    "podman-yamtrack-redis" = {
      after = [ "sops-nix.service" ];
      requires = lib.mkIf config.sops.useSystemdActivation [ "sops-install-secrets.service" ];
    };
    "podman-yamtrack" = {
      after = [
        "podman-yamtrack-redis.service"
        "sops-nix.service"
      ];
      requires = [ "podman-yamtrack-redis.service" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 root root -"
    "d ${dataDir}/db 0755 root root -"
    "d ${dataDir}/redis-data 0755 root root -"
  ];

  sops.secrets."yamtrack_env" = {
    sopsFile = ../../secrets/nixflix.yaml;
  };

  services.nginx = {
    enable = true;
    virtualHosts.${yamtrackHost} = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:8000";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
