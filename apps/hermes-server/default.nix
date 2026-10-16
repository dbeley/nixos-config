{
  pkgs,
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

  environment.etc."hermes/config.yaml".text = ''
    mcp_servers:
      rea:
        command: "${pkgs.nodejs}/bin/npx"
        args: ["-y", "rea-agents@6.5.0", "mcp"]
        env:
          GHIDRA_INSTALL_DIR: "${pkgs.ghidra}/lib/ghidra"
          JAVA_HOME: "${pkgs.jdk21}/lib/openjdk"
        enabled: true
  '';

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
