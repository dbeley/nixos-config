# Instance PeerTube publique.
#
# Ressources VM recommandées (Proxmox):
#   - vCPU:  2 (4 si transcodage vidéo intensif — ffmpeg logiciel)
#   - RAM:   4 Go minimum, 8 Go confortable (postgres + redis + node)
#   - Disque: 100-200 Go (vidéos + transcodages temporaires)
#   - Domaine public requis: DNS A → IP de la VM (TLS Let's Encrypt)
{
  pkgs,
  ...
}:
let
  # TODO: remplacer par le vrai domaine public de l'instance (DNS A → IP de la VM).
  peertubeDomain = "peertube.example.com";
  # TODO: email admin (utilisé par Let's Encrypt et affiché par PeerTube).
  adminEmail = "admin@example.com";
in
{
  services.peertube = {
    enable = true;
    localDomain = peertubeDomain;
    # Le module génère le reverse proxy nginx complet.
    configureNginx = true;
    # Accès public en HTTPS (port 443).
    enableWebHttps = true;
    listenWeb = 443;
    # Secrets générés au premier boot (hors du store Nix).
    secrets.secretsFile = "/var/lib/peertube/secret";
    serviceEnvironmentFile = "/var/lib/peertube/admin-env";
    # Postgres et Redis locaux (gérés par le module).
    database.createLocally = true;
    redis.createLocally = true;
    settings = {
      # Instance publique mais sans inscription ouverte (comptes créés par l'admin).
      signup.enabled = false;
      administration.email = adminEmail;
    };
  };

  # Génère les secrets au premier démarrage (persistants entre les reboots).
  systemd.services.peertube-secrets = {
    description = "Generate PeerTube secrets on first boot";
    before = [ "peertube.service" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ coreutils ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      install -d -o peertube -g peertube -m 0750 /var/lib/peertube
      if [ ! -s /var/lib/peertube/secret ]; then
        ${pkgs.openssl}/bin/openssl rand -hex 32 > /var/lib/peertube/secret
        chown peertube:peertube /var/lib/peertube/secret
        chmod 0600 /var/lib/peertube/secret
      fi
      if [ ! -s /var/lib/peertube/admin-env ]; then
        printf 'PT_INITIAL_ROOT_PASSWORD=%s\n' "$(${pkgs.openssl}/bin/openssl rand -base64 24)" > /var/lib/peertube/admin-env
        chown peertube:peertube /var/lib/peertube/admin-env
        chmod 0600 /var/lib/peertube/admin-env
      fi
    '';
  };

  # TLS Let's Encrypt pour le domaine de l'instance.
  services.nginx.virtualHosts.${peertubeDomain} = {
    enableACME = true;
    forceSSL = true;
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
