{
  config,
  domain,
  ...
}:
let
  hostName = "nitter.${domain}";
in
{
  services.nitter = {
    enable = true;
    server = {
      address = "0.0.0.0";
      port = 8080;
      hostname = hostName;
      https = true;
    };
    cache = {
      listMinutes = 240;
      rssMinutes = 10;
    };
    config = {
      enableRSS = true;
      enableDebug = false;
    };
    preferences = {
      replaceTwitter = "x";
      replaceYouTube = "piped";
      replaceReddit = "redlib";
      theme = "Nitter";
    };
    sessionsFile = config.sops.secrets."nitter_sessions".path;
    redisCreateLocally = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts.${hostName} = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:8080";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  sops.secrets."nitter_sessions" = {
    sopsFile = ../../secrets/nitter.yaml;
    owner = "nitter";
    group = "nitter";
    mode = "0440";
  };

  systemd.services.nitter = {
    after = [ "sops-nix.service" ];
    wants = [ "sops-nix.service" ];
  };
}
