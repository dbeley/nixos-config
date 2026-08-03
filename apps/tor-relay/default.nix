# Relais Tor non-exit.
#
# Ressources VM recommandées:
#   - vCPU: 1
#   - RAM:  1 Go (le relais consomme ~200-400 Mo)
#   - Disque: 20 Go (les données du relais prennent ~1-2 Go)
# La ressource clé est la bande passante (débit illimité du Kimsufi).
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
      # TODO: personnaliser (le Nickname doit être < 19 caractères).
      Nickname = "dbeleyKimsufiRelay";
      ContactInfo = "https://github.com/dbeley";
      ORPort = [ 443 ];
      # Limites de bande passante: 4 Mo/s en moyenne, 6 Mo/s en rafale.
      BandwidthRate = "4 MB";
      BandwidthBurst = "6 MB";
    };
  };
}
