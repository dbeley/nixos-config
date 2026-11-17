{
  config,
  pkgs,
  user,
  domain,
  ...
}:
let
  nfsServer = "omv.home";
  nfsMount = "/mnt/nfs";
  paperlessHost = "paperless.${domain}";
  paperlessUrl = "https://${paperlessHost}";

  # paperless-ngx 3.4.2 pins `torch<2.15` while nixpkgs ships 2.15.0, so the
  # wheel's runtime-dependency check fails at build time. The nixpkgs module
  # wraps `package` with `.override { tesseract5 = …; }`, which the result of
  # `overridePythonAttrs` does not provide, hence the shimmed `override`.
  paperlessPackage =
    let
      base = pkgs.paperless-ngx;
      patch =
        drv:
        drv.overridePythonAttrs (_: {
          dontCheckRuntimeDeps = true;
        });
    in
    patch base // { override = args: patch (base.override args); };
in
{
  fileSystems.${nfsMount} = {
    device = "${nfsServer}:/";
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
      requires = [ "mnt-nfs.mount" ];
      after = [ "mnt-nfs.mount" ];
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
    group = config.users.users.${user}.group;
    package = paperlessPackage;
    consumptionDir = "${nfsMount}/WDC14_2/Transferts/paperless-ngx";
    passwordFile = config.sops.secrets."paperless_admin_password".path;
    settings = {
      PAPERLESS_URL = paperlessUrl;
      PAPERLESS_OCR_LANGUAGE = "fra";
    };
  };

  users.users.${user}.extraGroups = [ config.services.redis.servers.paperless.group ];

  sops.secrets."paperless_admin_password" = {
    sopsFile = ../../secrets/homelab.yaml;
  };

  services.nginx = {
    enable = true;
    virtualHosts.${paperlessHost} = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:28981";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
