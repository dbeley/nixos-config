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
      "%include" = config.sops.secrets."tor_identity".path;
      ORPort = [ 443 ];
      BandwidthRate = "8 MB";
      BandwidthBurst = "10 MB";
    };
  };

  sops.secrets."tor_identity" = {
    sopsFile = ../../secrets/tor.yaml;
    owner = "tor";
    group = "tor";
    mode = "0440";
  };

  systemd.services.tor = {
    after = [ "sops-nix.service" ];
    wants = [ "sops-nix.service" ];
    serviceConfig.BindReadOnlyPaths = [ config.sops.secrets."tor_identity".path ];
  };
}
