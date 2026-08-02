{
  lib,
  ...
}:
let
  karakeepHost = "karakeep.home";
  karakeepPort = 3001;
in
{
  # pnpm is only used at build time to fetch/build karakeep deps; the runtime
  # output does not include it.
  nixpkgs.config.permittedInsecurePackages = [ "pnpm-9.15.9" ];

  services = {
    karakeep = {
      enable = true;
      extraEnvironment = {
        PORT = toString karakeepPort;
        NEXTAUTH_URL = "http://${karakeepHost}";
        DISABLE_SIGNUPS = "false";
        LOG_LEVEL = "notice";
      };
    };

    # meilisearch 1.51 renamed `experimental_dumpless_upgrade` to `upgrade_db`
    # (--upgrade-db / MEILI_UPGRADE_DB). nixpkgs' services.meilisearch module still
    # injects the old key (lib.mkDefault true), which 1.51 rejects as an unknown
    # config field, so the service crashes on start. Override the whole settings
    # block with the current key instead.
    meilisearch.settings = lib.mkForce {
      http_addr = "localhost:7700";
      db_path = "/var/lib/meilisearch";
      dump_dir = "/var/lib/meilisearch/dumps";
      snapshot_dir = "/var/lib/meilisearch/snapshots";
      no_analytics = true;
      upgrade_db = true;
    };

    nginx = {
      enable = true;
      virtualHosts.${karakeepHost} = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString karakeepPort}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = "client_max_body_size 500m;";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
