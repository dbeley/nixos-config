{
  config,
  ...
}:
let
  inherit (config.sops) secrets;
in
{
  nixflix = {
    enable = true;
    mediaDir = "/data/media";
    stateDir = "/data/.state";

    nginx = {
      enable = true;
      domain = "nixflix.home";
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
    };

    seerr = {
      enable = true;
      apiKey._secret = secrets."seerr_api_key".path;
    };

    recyclarr.enable = true;
    flaresolverr.enable = true;
  };

  sops.secrets = {
    "sonarr_api_key" = { };
    "sonarr_password" = { };
    "radarr_api_key" = { };
    "radarr_password" = { };
    "lidarr_api_key" = { };
    "lidarr_password" = { };
    "prowlarr_api_key" = { };
    "prowlarr_password" = { };
    "jellyfin_api_key" = { };
    "jellyfin_admin_password" = { };
    "seerr_api_key" = { };
    "qbittorrent_password" = { };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
