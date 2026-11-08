{
  domain,
  ...
}:
{
  services.redlib = {
    enable = true;
    address = "127.0.0.1";
    settings = {
      DEFAULT_THEME = "system";
    };
  };

  services.nginx.virtualHosts."redlib.${domain}" = {
    useACMEHost = domain;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:8080";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Real-IP $remote_addr;
        '';
      };
    };
  };
}
