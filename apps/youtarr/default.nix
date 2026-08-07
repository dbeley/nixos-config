{
  config,
  lib,
  pkgs,
  inputs,
  user,
  domain,
  ...
}:
let
  downloadDir = "/mnt/nfs/WDC14_2/Youtarr";
in
{
  imports = [ inputs.youtarr-flake.nixosModules.default ];

  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    youtarr = {
      enable = true;
      host = "127.0.0.1";
      database = {
        host = "127.0.0.1";
        user = "youtarr";
        name = "youtarr";
        passwordFile = config.sops.secrets."youtarr-env".path;
      };
      auth = {
        enable = true;
        presetUsername = "admin";
        presetPasswordFile = config.sops.secrets."youtarr-env".path;
      };
      environmentFile = config.sops.secrets."youtarr-env".path;
      youtubeOutputDir = downloadDir;
      settings = {
        darkModeEnabled = true;
        preferredResolution = "1080";
        channelAutoDownload = true;
        channelDownloadFrequency = "0 */6 * * *";
        writeVideoNfoFiles = true;
        subtitlesEnabled = true;
        subtitleLanguage = "fr";
        jellyfinEnabled = true;
        jellyfinUrl = "http://127.0.0.1:8096";
      };
      secretSettings = {
        jellyfinApiKey = "JELLYFIN_API_KEY";
      };
    };

    nginx.virtualHosts."youtarr.${domain}" = {
      useACMEHost = "${domain}";
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:3011";
    };
  };

  sops.secrets."youtarr-env" = {
    sopsFile = ../../secrets/nixflix.yaml;
    owner = "youtarr";
  };

  users.users.youtarr.extraGroups = [ "media" ];

  systemd.tmpfiles.settings."10-youtarr" = {
    "${downloadDir}".d = {
      mode = "0775";
      inherit user;
      group = "media";
    };
  };

  systemd.services = {
    # Create the MariaDB database, user and grants from the sops-provided
    # password so no secret lands in the Nix store.
    youtarr-db-init = {
      description = "Create Youtarr database and user";
      after = [
        "mysql.service"
        "sops-nix.service"
      ];
      requires = [ "mysql.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        EnvironmentFile = config.sops.secrets."youtarr-env".path;
      };
      script = ''
        DB_PASSWORD="''${DB_PASSWORD:-}"
        if [ -z "$DB_PASSWORD" ]; then
          echo "DB_PASSWORD not set in youtarr-env" >&2
          exit 1
        fi
        ${pkgs.mariadb}/bin/mysql <<SQL
        CREATE DATABASE IF NOT EXISTS youtarr CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS 'youtarr'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
        CREATE USER IF NOT EXISTS 'youtarr'@'127.0.0.1' IDENTIFIED BY '$DB_PASSWORD';
        GRANT ALL PRIVILEGES ON youtarr.* TO 'youtarr'@'localhost';
        GRANT ALL PRIVILEGES ON youtarr.* TO 'youtarr'@'127.0.0.1';
        FLUSH PRIVILEGES;
        SQL
      '';
    };

    youtarr = {
      after = lib.mkAfter [
        "youtarr-db-init.service"
        "mnt-nfs-WDC14_2.mount"
        "sops-nix.service"
      ];
      requires = [
        "youtarr-db-init.service"
      ];
    };
  };
}
