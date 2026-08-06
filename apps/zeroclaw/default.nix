{
  config,
  pkgs,
  inputs,
  domain,
  ...
}:
{
  imports = [ inputs.zeroclaw.nixosModules.default ];

  environment.systemPackages = [ pkgs.zeroclaw ];

  systemd.services."zeroclaw-me".path = [ pkgs.bash ];

  services.zeroclaw.instances.me = {
    environmentFile = config.sops.secrets."zeroclaw-env".path;
    settings = {
      schema_version = 3;
      gateway = {
        host = "127.0.0.1";
        port = 42617;
      };
      providers.models.openai.gohome = {
        model = "deepseek-v4-flash";
        uri = "https://opencode.ai/zen/go/v1";
        api_key = "$OPENCODE_API_KEY";
      };
      agents.assistant = {
        model_provider = "openai.gohome";
        risk_profile = "assistant";
      };
      risk_profiles.assistant = { };
    };
  };

  sops.secrets."zeroclaw-env" = {
    sopsFile = ../../secrets/agents.yaml;
  };

  services.nginx = {
    enable = true;
    virtualHosts."zeroclaw.${domain}" = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:42617";
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
