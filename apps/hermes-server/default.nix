{
  user,
  inputs,
  domain,
  ...
}:
{
  imports = [ inputs.hermes-webui-nix.nixosModules.default ];
  services.hermes-webui = {
    enable = true;
    port = 8787;
    inherit user;
  };

  services.nginx = {
    enable = true;
    virtualHosts."hermes.${domain}" = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8787";
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
