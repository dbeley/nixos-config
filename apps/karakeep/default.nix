let
  karakeepHost = "karakeep.home";
  karakeepPort = 3001;
in
{
  # pnpm is only used at build time to fetch/build karakeep deps; the runtime
  # output does not include it.
  nixpkgs.config.permittedInsecurePackages = [ "pnpm-9.15.9" ];

  services.karakeep = {
    enable = true;
    extraEnvironment = {
      PORT = toString karakeepPort;
      NEXTAUTH_URL = "http://${karakeepHost}";
      DISABLE_SIGNUPS = "false";
      LOG_LEVEL = "notice";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts.${karakeepHost} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString karakeepPort}";
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
