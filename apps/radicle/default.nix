# Seed node Radicle — contribue au réseau peer-to-peer en hébergeant des dépôts
# (bande passante + disponibilité 24/7, parfait pour le rôle Kimsufi).
#
# Ressources VM recommandées (Proxmox):
#   - vCPU: 1-2
#   - RAM:  1-2 Go (guide officiel : 1-2 Go suffisent)
#   - Disque: 20-50 Go (grossit avec les dépôts répliqués ; 50 Go pour un seed permissif)
#   - Réseau: 1 IP publique + domaine (seed.home.dbeley.ovh),
#     ports 8776 (gossip) + 80/443 (UI web)
{
  domain,
  config,
  ...
}:
let
  # Le seed est un sous-domaine du domaine hôte (convention du repo:
  # le profil `acme` émet un cert pour le domaine hôte + ses sous-domaines
  # directs, cf. apps/slskd sur nixos-era-music).
  seedDomain = "seed.${domain}";
in
{
  services.radicle = {
    enable = true;
    # Identité du nœud (clé SSH ed25519 générée par `rad auth`), stockée dans sops.
    # Le module l'importe via LoadCredential (fichier déchiffré par sops-nix).
    # Attention: le type doit être un path (et non une string) pour que le module
    # utilise LoadCredential et non ImportCredential.
    # builtins.toPath est déprécié (voir statix.toml) mais reste le seul moyen
    # sûr de convertir une string en path en évaluation pure (/. + "/path"
    # déclenche "access to absolute path forbidden" hors du store).
    privateKey = builtins.toPath config.sops.secrets."radicle-key".path;
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqlsSsMw8287uVxuF8dcmrKNrIclywnfnFzR/f0ci0T";
    node = {
      # Port de gossip (8776) ouvert sur le réseau public.
      openFirewall = true;
    };
    settings = {
      node = {
        alias = seedDomain;
        # Politique permissive : réplique tout le réseau (seed public).
        # Pour un seed sélectif, remplacer par { default = "block"; }
        # puis autoriser les dépôts via `rad seed <rid>` (ou `rad-system seed <rid>`).
        seedingPolicy = {
          default = "allow";
          scope = "all";
        };
      };
    };
    httpd = {
      enable = true;
      # UI web + API HTTP du seed, derrière nginx avec TLS Let's Encrypt.
      # Le cert du domaine hôte (profil `acme`) couvre seed.<domain>.
      nginx = {
        serverName = seedDomain;
        useACMEHost = domain;
        forceSSL = true;
        enableACME = false;
      };
    };
  };

  sops.secrets."radicle-key" = {
    sopsFile = ../../secrets/radicle.yaml;
  };

  # Attendre le déchiffrement sops au boot (clé importée via LoadCredential).
  systemd.services.radicle-node = {
    after = [ "sops-nix.service" ];
    wants = [ "sops-nix.service" ];
  };
  systemd.services.radicle-httpd = {
    after = [ "sops-nix.service" ];
    wants = [ "sops-nix.service" ];
  };

  # nginx (UI web) : 80/443 — 8776 est déjà ouvert via node.openFirewall.
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
