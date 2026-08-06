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

  soularrConfig = pkgs.writeText "soularr-config.ini" ''
    [Lidarr]
    api_key = ''${LIDARR_API_KEY}
    host_url = http://127.0.0.1:8686
    download_dir = /data/slskd
    disable_sync = False

    [Slskd]
    api_key = ''${SLSKD_API_KEY}
    host_url = http://127.0.0.1:5030
    url_base = /
    download_dir = /downloads
    delete_searches = False
    stalled_timeout = 3600
    remote_queue_timeout = 300

    [Release Settings]
    use_selected_lidarr_release = False
    use_most_common_tracknum = True
    allow_multi_disc = True
    accepted_countries = Europe,Japan,United Kingdom,United States,[Worldwide],Australia,Canada
    skip_region_check = False
    accepted_formats = CD,Digital Media,Vinyl

    [Search Settings]
    search_timeout = 5000
    maximum_peer_queue = 50
    minimum_peer_upload_speed = 0
    minimum_filename_match_ratio = 0.8
    minimum_search_interval = 5
    allowed_filetypes = flac 24/192,flac 16/44.1,flac,mp3 320,mp3
    ignored_users =
    album_prepend_artist = False
    search_type = incrementing_page
    number_of_albums_to_grab = 10
    title_blacklist =
    search_blacklist =
    search_source = missing
    failed_import_denylist = True

    [Download Settings]
    download_filtering = True
    use_extension_whitelist = False
    extensions_whitelist = lrc,nfo,txt
    rename_download_folders = True

    [Logging]
    level = INFO
    format = [%(levelname)s|%(module)s|L%(lineno)d] %(asctime)s: %(message)s
    datefmt = %Y-%m-%dT%H:%M:%S%z
    log_to_file = True
    log_file = soularr.log
    max_bytes = 1048576
    backup_count = 3
  '';
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
    serviceDependencies = [ "mnt-nfs-WDC14_2.mount" ];

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
            tags = [ "flaresolverr" ];
          }
          {
            name = "EZTV";
          }
          {
            name = "LimeTorrents";
          }
          {
            name = "YTS";
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

  services.slskd = {
    enable = true;
    user = "lidarr";
    group = "media";
    environmentFile = secrets."slskd-env".path;
    openFirewall = true;
    domain = "slskd.nixflix.${domain}";
    nginx = {
      useACMEHost = "nixflix.${domain}";
      forceSSL = true;
    };
    settings = {
      shares.directories = [ "/mnt/nfs/WDC14_2/Nixflix/music" ];
      directories = {
        downloads = "/data/slskd";
        incomplete = "/data/slskd/incomplete";
      };
      web.port = 5030;
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.soularr = {
      image = "ghcr.io/mrusse/soularr:latest";
      user = "306:169";
      volumes = [
        "/data/slskd:/downloads"
        "/data/soularr:/data"
        "${soularrConfig}:/data/config.ini:ro"
      ];
      environmentFiles = [ secrets."soularr-env".path ];
      environment = {
        TZ = "Europe/Paris";
        SCRIPT_INTERVAL = "300";
      };
      extraOptions = [ "--network=host" ];
    };
  };

  systemd = {
    services = {
      podman-soularr = {
        after = [
          "nixflix-setup-dirs.service"
          "slskd.service"
          "sops-nix.service"
        ];
        requires = [ "nixflix-setup-dirs.service" ];
      };

      nixflix-setup-dirs.script = lib.mkForce ''
        ${pkgs.systemd}/bin/systemd-tmpfiles --create --prefix=/data --prefix=/var
      '';

      slskd.after = lib.mkAfter [ "mnt-nfs-WDC14_2.mount" ];

      wg.serviceConfig = {
        Restart = "on-failure";
        RestartSec = 30;
      };
    };

    tmpfiles.settings."10-soularr" = {
      "/data/slskd".d = {
        user = "lidarr";
        group = "media";
        mode = "0775";
      };
      "/data/slskd/incomplete".d = {
        user = "lidarr";
        group = "media";
        mode = "0775";
      };
      "/data/soularr".d = {
        user = "lidarr";
        group = "media";
        mode = "0775";
      };
    };
  };

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
        "slskd-env"
        "soularr-env"
      ]
      (_: {
        sopsFile = ../../secrets/nixflix.yaml;
      });

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
