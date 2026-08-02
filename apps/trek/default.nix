{
  config,
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
      image = "mauriceboe/trek:latest";
      autoStart = true;
      ports = [ "127.0.0.1:${toString trekPort}:3000" ];
      volumes = [
        "${trekData}:/app/data"
        "${trekUploads}:/app/uploads"
      ];
      environmentFiles = [ config.sops.secrets."trek-env".path ];
      extraOptions = [ "--pull=newer" ];
    };
  };

  systemd.services."podman-trek" = {
    requires = [ "sops-nix.service" ];
    after = [ "sops-nix.service" ];
  };

  systemd.tmpfiles.rules = [
    "d ${trekData} 0755 root root -"
    "d ${trekUploads} 0755 root root -"
  ];

  sops.secrets."trek-env" = { };

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
