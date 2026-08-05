{
  config,
  user,
  domain,
  ...
}:
let
  hostName = "nextcloud.${domain}";
  inherit (config.sops) secrets;
in
{
  services.nextcloud = {
    enable = true;
    inherit hostName;
    https = true;

    config = {
      adminuser = user;
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
        bookmarks
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

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx.virtualHosts.${hostName} = {
    useACMEHost = domain;
    forceSSL = true;
  };

  sops.secrets = {
    "nextcloud_admin_password" = {
      sopsFile = ../../secrets/nextcloud.yaml;
    };
  };
}
