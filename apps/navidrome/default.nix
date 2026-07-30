{
  config,
  lib,
  user,
  ...
}:
let
  nfsServer = "omv.home";
  nfsExport = "/WDC14";
  nfsMount = "/mnt/nfs/WDC14";
in
{
  fileSystems.${nfsMount} = {
    device = "${nfsServer}:${nfsExport}";
    fsType = "nfs";
    options = [
      "_netdev"
      "nofail"
      "hard"
      "timeo=60"
      "retrans=3"
    ];
  };

  systemd.tmpfiles.settings."navidrome-nfs-symlink" = {
    "/home/${user}/nfs".L.argument = "/mnt/nfs";
  };

  # navidrome module sets ProtectHome=true, so MusicFolder must be under /mnt.
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      Address = "0.0.0.0";
      MusicFolder = "${nfsMount}/Musique";
      DefaultLanguage = "fr";
    };
    environmentFile = config.sops.secrets."navidrome-env".path;
  };

  sops.secrets."navidrome-env" = { };

  systemd.services.navidrome = {
    requires = [ "mnt-nfs-WDC14.mount" ];
    after = [
      "mnt-nfs-WDC14.mount"
      "network-online.target"
      "sops-nix.service"
    ];
    serviceConfig.BindReadOnlyPaths = lib.mkAfter [ "/run/secrets" ];
  };
}
