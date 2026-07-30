{
  config,
  lib,
  ...
}:
{
  sops.secrets."slskd-env" = { };

  services.slskd = {
    enable = true;
    environmentFile = config.sops.secrets."slskd-env".path;
    openFirewall = true;
    domain = "slskd.navidrome.home";
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
