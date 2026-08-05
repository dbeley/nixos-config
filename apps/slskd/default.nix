{
  config,
  lib,
  user,
  domain,
  ...
}:
{
  sops.secrets."slskd-env" = {
    sopsFile = ../../secrets/navidrome.yaml;
  };

  services.slskd = {
    enable = true;
    environmentFile = config.sops.secrets."slskd-env".path;
    openFirewall = true;
    domain = "slskd.${domain}";
    nginx = {
      useACMEHost = domain;
      forceSSL = true;
    };
    inherit user;
    group = "users";
    settings = {
      shares.directories = [ "/mnt/nfs/WDC14/Musique" ];
      directories = {
        downloads = "/mnt/nfs/WDC14/Soulseek";
        incomplete = "/mnt/nfs/WDC14/Soulseek/incomplete";
      };
    };
  };

  systemd.services.slskd = {
    requires = [ "mnt-nfs-WDC14.mount" ];
    after = [
      "mnt-nfs-WDC14.mount"
      "network-online.target"
      "sops-nix.service"
    ];
    serviceConfig.BindReadOnlyPaths = lib.mkAfter [ "/run/secrets" ];
  };
}
