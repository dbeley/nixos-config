{ config, ... }:
let
  inherit (config.sops) secrets;
in
{
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud-nixos.home";
    https = false;

    config = {
      adminuser = "admin";
      adminpassFile = secrets."nextcloud_admin_password".path;
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
    };

    database.createLocally = true;

    configureRedis = true;
    caching.apcu = true;

    maxUploadSize = "16G";

    autoUpdateApps.enable = true;
    extraAppsEnable = true;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit
        contacts
        notes
        calendar
        tasks
        ;
    };

    settings = {
      default_phone_region = "FR";
      maintenance = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  sops.secrets = {
    "nextcloud_admin_password" = { };
  };
}
