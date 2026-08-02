{
  config,
  lib,
  ...
}:
let
  trekHost = "trek.home";
  trekPort = 3000;
  trekData = "/var/lib/trek/data";
  trekUploads = "/var/lib/trek/uploads";
in
{
  virtualisation = {
    podman.enable = true;
    oci-containers.containers.trek = {
      image = "docker.io/mauriceboe/trek:latest";
      autoStart = true;
      ports = [ "127.0.0.1:${toString trekPort}:3000" ];
      volumes = [
        "${trekData}:/app/data"
        "${trekUploads}:/app/uploads"
      ];
      environment = {
        TZ = "Europe/Paris";
        APP_URL = "http://${trekHost}";
        ALLOWED_ORIGINS = "http://${trekHost}";
        DEFAULT_LANGUAGE = "fr";
        COOKIE_SECURE = "false";
      };
      environmentFiles = [ config.sops.secrets."trek-env".path ];
      extraOptions = [ "--pull=newer" ];
    };
  };

  systemd.services."podman-trek" = {
    requires = lib.mkIf config.sops.useSystemdActivation [ "sops-install-secrets.service" ];
    after = lib.mkIf config.sops.useSystemdActivation [ "sops-install-secrets.service" ];
  };

  systemd.tmpfiles.rules = [
    "d ${trekData} 0755 root root -"
    "d ${trekUploads} 0755 root root -"
  ];

  sops.secrets."trek-env" = {
    sopsFile = ../../secrets/homelab.yaml;
  };

  services.nginx = {
    enable = true;
    virtualHosts.${trekHost} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString trekPort}";
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
