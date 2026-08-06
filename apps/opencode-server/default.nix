{
  config,
  pkgs,
  inputs,
  user,
  domain,
  ...
}:
{
  systemd.services.opencode-web = {
    description = "OpenCode web UI";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network-online.target"
      "sops-nix.service"
    ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      User = user;
      Environment = [
        "HOME=/home/${user}"
        "OPENCODE_DISABLE_FFF=1"
      ];
      ExecStart = "${
        inputs.llm-agents.packages.${pkgs.system}.opencode
      }/bin/opencode serve --hostname 127.0.0.1 --port 4096";
      EnvironmentFile = config.sops.secrets."opencode-env".path;
      Restart = "always";
      RestartSec = 5;
    };
  };

  sops.secrets."opencode-env" = {
    sopsFile = ../../secrets/agents.yaml;
  };

  services.nginx = {
    enable = true;
    virtualHosts."opencode.${domain}" = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4096";
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
