{
  config,
  lib,
  domain,
  ...
}:
let
  directSubdomains = lib.filter (h: builtins.match "[^.]+\.${domain}" h != null) (
    lib.attrNames config.services.nginx.virtualHosts
  );
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@${domain}";
    certs.${domain} = lib.mkIf (directSubdomains != [ ]) {
      inherit domain;
      extraDomainNames = directSubdomains;
      dnsProvider = "ovh";
      environmentFile = config.sops.secrets."acme-ovh".path;
      group = "nginx";
    };
  };

  sops.secrets."acme-ovh" = {
    sopsFile = ../../secrets/acme.yaml;
    owner = "acme";
  };
}
