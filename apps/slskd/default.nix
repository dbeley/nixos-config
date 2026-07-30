{ config, ... }:
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
}
