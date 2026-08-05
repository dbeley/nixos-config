{
  config,
  lib,
  user,
  pkgs,
  inputs,
  domain,
  ...
}:
let
  inherit (config.sops) secrets;
in
{
  imports = [ inputs.nixflix.nixosModules.default ];
  fileSystems."/mnt/nfs/WDC14_2" = {
    device = "omv.home:/WDC14_2";
    fsType = "nfs";
    options = [
      "_netdev"
      "nofail"
      "hard"
      "timeo=60"
      "retrans=3"
    ];
  };

  nixflix = {
    enable = true;
    mediaDir = "/mnt/nfs/WDC14_2/Nixflix";
    stateDir = "/data/.state";
    downloadsDir = "/mnt/nfs/WDC14_2/Downloads/Nixflix";
    mediaUsers = [ user ];
    globals.libraryOwner = {
      inherit user;
      group = "media";
    };

    nginx = {
      enable = true;
      domain = "nixflix.${domain}";
      forceSSL = true;
      enableACME = true;
      addHostsEntries = true;
    };

    sonarr = {
      enable = true;
      config = {
        apiKey._secret = secrets."sonarr_api_key".path;
        hostConfig.password._secret = secrets."sonarr_password".path;
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKey._secret = secrets."radarr_api_key".path;
        hostConfig.password._secret = secrets."radarr_password".path;
      };
    };

    lidarr = {
      enable = true;
      config = {
        apiKey._secret = secrets."lidarr_api_key".path;
        hostConfig.password._secret = secrets."lidarr_password".path;
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey._secret = secrets."prowlarr_api_key".path;
        hostConfig.password._secret = secrets."prowlarr_password".path;
        indexers = [
          {
            name = "RuTracker.org";
            username._secret = secrets."rutracker_username".path;
            password_secret._secret = secrets."rutracker_password".path;
          }
          {
            name = "The Pirate Bay";
          }
          {
            name = "1337x";
          }
        ];
      };
    };

    jellyfin = {
      enable = true;
      apiKey._secret = secrets."jellyfin_api_key".path;
      users.admin = {
        mutable = false;
        policy.isAdministrator = true;
        password._secret = secrets."jellyfin_admin_password".path;
      };
    };

    torrentClients.qbittorrent = {
      enable = true;
      password._secret = secrets."qbittorrent_password".path;
      serverConfig.Preferences.WebUI = {
        Username = "admin";
        Password_PBKDF2 = "@ByteArray(VuvMO6udxeXWsDTCJiL4pw==:r5rg6+RmXxEsgUuFleFaxYQB2iUFL3QlFLa2/UBYu8aJ8xDYrLA5iD220MZp+713FgaTZybTCrc392rpoaCT0w==)";
      };
    };

    seerr = {
      enable = true;
      apiKey._secret = secrets."seerr_api_key".path;
    };

    recyclarr.enable = true;
    flaresolverr.enable = true;

    vpn = {
      enable = true;
      wgConfFile = config.sops.secrets."mullvad_wg".path;
    };
  };

  security.acme.certs."nixflix.${domain}" = {
    domain = "nixflix.${domain}";
    extraDomainNames = [ "*.nixflix.${domain}" ];
    dnsProvider = "ovh";
    environmentFile = config.sops.secrets."acme-ovh".path;
    group = "nginx";
  };

  systemd.services.nixflix-setup-dirs.script = lib.mkForce ''
    ${pkgs.systemd}/bin/systemd-tmpfiles --create --prefix=/data --prefix=/var
  '';

  sops.secrets =
    lib.genAttrs
      [
        "sonarr_api_key"
        "sonarr_password"
        "radarr_api_key"
        "radarr_password"
        "lidarr_api_key"
        "lidarr_password"
        "prowlarr_api_key"
        "prowlarr_password"
        "jellyfin_api_key"
        "jellyfin_admin_password"
        "seerr_api_key"
        "qbittorrent_password"
        "rutracker_username"
        "rutracker_password"
        "mullvad_wg"
      ]
      (_: {
        sopsFile = ../../secrets/nixflix.yaml;
      });

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
