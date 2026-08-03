# Cache binaire Nix (Attic) + remote builder.
#
# Ressources VM recommandées (Proxmox):
#   - vCPU: 1-2 (remote builder)
#   - RAM:  2 Go (4 Go si builds distribués actifs)
#   - Disque: 50-100 Go (chunks + store local)
#   - Domaine public requis: DNS A → IP de la VM (TLS Let's Encrypt)
{
  lib,
  pkgs,
  ...
}:
let
  # TODO: domaine public du cache (DNS A → IP de la VM).
  atticDomain = "attic.example.com";
  # TODO: email admin (utilisé par Let's Encrypt).
  adminEmail = "admin@example.com";
in
{
  services.atticd = {
    enable = true;
    # Secret JWT RS256 généré au premier boot (hors du store Nix).
    environmentFile = "/var/lib/atticd-secret/env";
    settings = {
      listen = "127.0.0.1:8080";
      allowed-hosts = [ atticDomain ];
      # L'endpoint API doit se terminer par un slash.
      api-endpoint = "https://${atticDomain}/";
    };
  };

  # Génère le secret JWT RS256 au premier démarrage (persistant entre les reboots).
  systemd.services.atticd-secret-init = {
    description = "Generate atticd JWT secret on first boot";
    before = [ "atticd.service" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      coreutils
      openssl
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      install -d -m 0700 /var/lib/atticd-secret
      if [ ! -s /var/lib/atticd-secret/env ]; then
        umask 077
        printf 'ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64="%s"\n' "$(${pkgs.openssl}/bin/openssl genrsa -traditional 4096 2>/dev/null | ${pkgs.coreutils}/bin/base64 -w0)" > /var/lib/atticd-secret/env
      fi
    '';
  };

  # Remote builder: les machines de david (clés SSH GitHub) peuvent déléguer
  # des builds Nix à cette machine (nix-store --serve --write).
  nix.sshServe = {
    enable = true;
    write = true;
    trusted = true;
  };
  users.users.nix-ssh.openssh.authorizedKeys.keyFiles = [
    (pkgs.fetchurl {
      url = "https://github.com/dbeley.keys";
      sha256 = "m3UIHF7Vp6Tut5RAgXcZ9+gnu6V0a/2doEVpIOij+kw=";
    })
  ];

  # Machine de build: autoriser plusieurs jobs simultanés.
  nix.settings.max-jobs = lib.mkDefault 4;

  # Reverse proxy nginx + TLS Let's Encrypt.
  services.nginx = {
    enable = true;
    virtualHosts.${atticDomain} = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:8080";
      # Les NAR peuvent être volumineux: pas de limite de body, pas de buffering.
      locations."/".extraConfig = ''
        client_max_body_size 0;
        proxy_request_buffering off;
      '';
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = adminEmail;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
