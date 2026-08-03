# Instance PeerTube publique.
#
# Ressources VM recommandées (Proxmox):
#   - vCPU:  2 (4 si transcodage vidéo intensif — ffmpeg logiciel)
#   - RAM:   4 Go minimum, 8 Go confortable (postgres + redis + node)
#   - Disque: 100-200 Go (vidéos + transcodages temporaires)
#   - Domaine public requis: DNS A → IP de la VM (TLS Let's Encrypt)
{
  config,
  lib,
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
    # Secrets sops (déchiffrés au boot par sops-nix, fichier secrets/peertube.yaml).
    secrets.secretsFile = config.sops.secrets."peertube-secret".path;
    serviceEnvironmentFile = config.sops.secrets."peertube-admin-password".path;
    # Postgres et Redis locaux (gérés par le module).
    database.createLocally = true;
    redis.createLocally = true;
    settings = {
      # Instance publique mais sans inscription ouverte (comptes créés par l'admin).
      signup.enabled = false;
      administration.email = adminEmail;
    };
  };

  sops.secrets = {
    "peertube-secret" = {
      sopsFile = ../../secrets/peertube.yaml;
      # Le service tourne en peertube:peertube et lit le secret au démarrage.
      owner = "peertube";
      group = "peertube";
      mode = "0440";
    };
    "peertube-admin-password" = {
      sopsFile = ../../secrets/peertube.yaml;
      owner = "peertube";
      group = "peertube";
      mode = "0440";
    };
  };

  # Attendre le déchiffrement sops au boot.
  systemd.services.peertube = {
    after = [ "sops-nix.service" ];
    wants = [ "sops-nix.service" ];
    serviceConfig.BindReadOnlyPaths = lib.mkAfter [ "/run/secrets" ];
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
