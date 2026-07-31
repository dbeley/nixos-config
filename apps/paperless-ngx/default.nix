{
  config,
  user,
  ...
}:
let
  nfsServer = "omv.home";
  nfsExport = "/WDC14_2";
  nfsMount = "/mnt/nfs/WDC14_2";
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

  systemd = {
    services.paperless-consumer = {
      requires = [ "mnt-nfs-root.mount" ];
      after = [ "mnt-nfs-root.mount" ];
    };

    services.paperless-scheduler = {
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "sops-nix.service"
      ];
    };
  };

  services.paperless = {
    enable = true;
    inherit user;
    consumptionDir = "${nfsMount}/Transferts/paperless-ngx";
    passwordFile = config.sops.secrets."paperless_admin_password".path;
    settings = {
      PAPERLESS_OCR_LANGUAGE = "fra";
    };
  };

  sops.secrets."paperless_admin_password" = { };

  services.nginx = {
    enable = true;
    virtualHosts."paperless.home" = {
      locations."/".proxyPass = "http://localhost:28981";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
