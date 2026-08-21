{
  config,
  domain,
  ...
}:
let
  host = "tubearchivist.${domain}";
  dataDir = "/var/lib/tubearchivist";
  mediaDir = "/mnt/nfs/WDC14_2/TubeArchivist";
  mountUnit = "mnt-nfs-WDC14_2.mount";
  tubearchivistPassword = config.sops.secrets."tubearchivist-password".path;
  elasticsearchPassword = config.sops.secrets."tubearchivist-elasticsearch-password".path;
  serviceDependencies = {
    after = [
      mountUnit
      "sops-nix.service"
    ];
    requires = [ mountUnit ];
  };
in
{
  fileSystems."/mnt/nfs/WDC14_2" = {
    device = "omv.home:/WDC14_2";
    fsType = "nfs";
    options = [
      "_netdev"
      "nofail"
      "hard"
      "timeo=60"
      "retrans=3"
    ];
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      tubearchivist-redis = {
        image = "docker.io/library/redis:7-alpine";
        autoStart = true;
        volumes = [ "${dataDir}/redis:/data" ];
      };

      tubearchivist-es = {
        image = "docker.io/bbilly1/tubearchivist-es";
        autoStart = true;
        environment = {
          ES_JAVA_OPTS = "-Xms1g -Xmx1g";
          "xpack.security.enabled" = "true";
          "discovery.type" = "single-node";
          "path.repo" = "/usr/share/elasticsearch/data/snapshot";
        };
        environmentFiles = [ elasticsearchPassword ];
        volumes = [ "${dataDir}/elasticsearch:/usr/share/elasticsearch/data" ];
        extraOptions = [
          "--ulimit=memlock=-1:-1"
        ];
      };

      tubearchivist = {
        image = "docker.io/bbilly1/tubearchivist:v0.5.10";
        autoStart = true;
        ports = [ "127.0.0.1:8000:8000" ];
        environment = {
          ES_URL = "http://tubearchivist-es:9200";
          REDIS_CON = "redis://tubearchivist-redis:6379";
          TA_HOST = "https://${host}";
          TA_USERNAME = "tubearchivist";
          TZ = "Europe/Paris";
        };
        environmentFiles = [
          tubearchivistPassword
          elasticsearchPassword
        ];
        volumes = [
          "${mediaDir}:/youtube"
          "${dataDir}/cache:/cache"
        ];
      };
    };
  };

  systemd.services = {
    "podman-tubearchivist-redis" = serviceDependencies;
    "podman-tubearchivist-es" = serviceDependencies;
    "podman-tubearchivist" = serviceDependencies // {
      after = serviceDependencies.after ++ [
        "podman-tubearchivist-redis.service"
        "podman-tubearchivist-es.service"
      ];
      requires = serviceDependencies.requires ++ [
        "podman-tubearchivist-redis.service"
        "podman-tubearchivist-es.service"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 root root -"
    "d ${dataDir}/cache 0755 root root -"
    "d ${dataDir}/elasticsearch 0755 1000 1000 -"
    "d ${dataDir}/redis 0755 root root -"
  ];

  sops.secrets."tubearchivist-password" = {
    sopsFile = ../../secrets/homelab.yaml;
  };

  sops.secrets."tubearchivist-elasticsearch-password" = {
    sopsFile = ../../secrets/homelab.yaml;
  };

  services.nginx.virtualHosts.${host} = {
    useACMEHost = domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8000";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
