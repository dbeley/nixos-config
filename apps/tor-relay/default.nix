{
  config,
  ...
}:
{
  services.tor = {
    enable = true;
    openFirewall = true;
    relay = {
      enable = true;
      role = "relay";
    };
    settings = {
      "%include" = config.sops.secrets."tor-identity".path;
      ORPort = [ 443 ];
      BandwidthRate = "6 MB";
      BandwidthBurst = "8 MB";
    };
  };

  sops.secrets."tor-identity" = {
    sopsFile = ../../secrets/tor.yaml;
    owner = "tor";
    group = "tor";
    mode = "0440";
  };

  systemd.services.tor = {
    after = [ "sops-nix.service" ];
    wants = [ "sops-nix.service" ];
    serviceConfig.BindReadOnlyPaths = [ config.sops.secrets."tor-identity".path ];
  };
}
