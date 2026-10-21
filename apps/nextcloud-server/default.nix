{
  config,
  domain,
  ...
}:
let
  hostName = "nextcloud.${domain}";
in
{
  services.nextcloud = {
    enable = true;
    inherit hostName;
    https = true;

    # No admin user is created by the module anymore. On a fresh install,
    # create it manually. nextcloud-occ re-execs itself as the `nextcloud`
    # user and only forwards NC_PASS/OC_PASS, so no sudo needed:
    #   NC_PASS='<strong-password>' nextcloud-occ user:add admin --password-from-env
    #   nextcloud-occ group:adduser admin admin
    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
    };

    database.createLocally = true;

    configureRedis = true;
    caching.apcu = true;

    maxUploadSize = "16G";

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
}
