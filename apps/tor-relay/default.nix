# Relais Tor non-exit.
#
# Ressources VM recommandées:
#   - vCPU: 1
#   - RAM:  1 Go (le relais consomme ~200-400 Mo)
#   - Disque: 20 Go (les données du relais prennent ~1-2 Go)
# La ressource clé est la bande passante (débit illimité du Kimsufi).
#
# L'identité du relais (Nickname/ContactInfo) est stockée chiffrée dans
# secrets/tor.yaml (sops) et injectée dans torrc via `%include` :
# le module tor de nixpkgs ne supporte pas le motif `_secret` dans settings.
{
  config,
  ...
}:
{
  services.tor = {
    enable = true;
    # Ouvre automatiquement le(s) port(s) du relais dans le firewall.
    openFirewall = true;
    relay = {
      enable = true;
      # "relay" = relais non-exit: on relaie le trafic onion entre nœuds Tor,
      # jamais vers l'Internet public (le module force ExitPolicy "reject *:*").
      role = "relay";
    };
    settings = {
      # Fragment torrc déchiffré par sops-nix au boot (Nickname + ContactInfo).
      "%include" = config.sops.secrets."tor-identity".path;
      ORPort = [ 443 ];
      # Limites de bande passante: 4 Mo/s en moyenne, 6 Mo/s en rafale.
      BandwidthRate = "4 MB";
      BandwidthBurst = "6 MB";
    };
  };

  # Identité du relais (Nickname < 19 caractères, ContactInfo publique) hors
  # du repo public. La clé age privée de l'hôte doit être installée sur la VM
  # (~/.config/sops/age/keys.txt) avant le premier boot.
  sops.secrets."tor-identity" = {
    sopsFile = ../../secrets/tor.yaml;
    owner = "tor";
    group = "tor";
    mode = "0440";
  };

  systemd.services.tor = {
    # Attendre le déchiffrement sops au boot.
    after = [ "sops-nix.service" ];
    wants = [ "sops-nix.service" ];
    # Le service tor tourne chrooté (RootDirectory=/run/tor/root) : le secret
    # doit être monté dans le namespace du service pour être visible de torrc.
    serviceConfig.BindReadOnlyPaths = [ config.sops.secrets."tor-identity".path ];
  };
}
