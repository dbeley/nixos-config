{
  config,
  lib,
  pkgs,
  user,
  domain,
  ...
}:
let
  cfg = config.services.pi-web;

  # Hostnames pi-web accepts in Host/Origin, on top of the bind address.
  allowedHostnames = lib.optional (cfg.vhost != null) cfg.vhost ++ cfg.allowedHosts;
in
{
  options.services.pi-web = {
    enable = lib.mkEnableOption "pi-web, a browser UI for the pi coding agent";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix { };
      defaultText = lib.literalExpression "pkgs.callPackage ./package.nix { }";
      description = "The pi-web package to run.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = user;
      description = ''
        User whose pi agent directory (`~/.pi/agent`) is served. Sessions,
        models and credentials are shared with the pi CLI of that user.
      '';
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address pi-web listens on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 30141;
      description = "Port pi-web listens on.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = config.sops.secrets."pi_web_env".path;
      defaultText = lib.literalExpression ''config.sops.secrets."pi_web_env".path'';
      description = ''
        Environment file in KEY=VALUE format. It must provide
        `PI_WEB_PASSWORD` whenever pi-web does not listen on loopback; API keys
        for model providers can be configured through the web UI instead.
      '';
    };

    allowedHosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra exact hostnames accepted by pi-web, on top of the nginx vhost.
        Required when a reverse proxy forwards an external hostname.
      '';
    };

    vhost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "pi.${domain}";
      description = ''
        nginx virtual host proxying to pi-web, with a certificate from the ACME
        module. Set to null to skip the vhost (and the firewall rules).
      '';
    };
  };

  config = lib.mkMerge [
    # Importing this module (through the "pi-web" profile) turns the service on;
    # hosts can still opt out with services.pi-web.enable = false.
    { services.pi-web.enable = lib.mkDefault true; }

    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.hostname == "127.0.0.1" || cfg.environmentFile != null;
          message = ''
            services.pi-web is reachable from the network but has no
            environmentFile providing PI_WEB_PASSWORD. pi-web runs an agent with
            the privileges of "${cfg.user}"; do not expose it unauthenticated.
          '';
        }
      ];

      sops.secrets."pi_web_env" = {
        sopsFile = ../../secrets/agents.yaml;
      };

      systemd.services.pi-web = {
        description = "pi-web, browser UI for the pi coding agent";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network-online.target"
          "sops-nix.service"
        ];
        wants = [ "network-online.target" ];

        environment = {
          HOME = "/home/${cfg.user}";
          PI_WEB_NO_OPEN = "1";
          PI_WEB_SKIP_VERSION_CHECK = "1";
        }
        // lib.optionalAttrs (allowedHostnames != [ ]) {
          PI_WEB_ALLOWED_HOSTS = lib.concatStringsSep "," allowedHostnames;
        };

        # git for the diff/worktree views, ripgrep and fd for file search.
        path = with pkgs; [
          bash
          coreutils
          fd
          git
          ripgrep
        ];

        serviceConfig = {
          User = cfg.user;
          WorkingDirectory = "/home/${cfg.user}";
          ExecStart = ''
            ${cfg.package}/bin/pi-web --no-open \
              --hostname ${cfg.hostname} \
              --port ${toString cfg.port}
          '';
          Restart = "always";
          RestartSec = 5;
        }
        // lib.optionalAttrs (cfg.environmentFile != null) {
          EnvironmentFile = cfg.environmentFile;
        };
      };

      services.nginx = lib.mkIf (cfg.vhost != null) {
        enable = true;
        virtualHosts.${cfg.vhost} = {
          useACMEHost = domain;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://${cfg.hostname}:${toString cfg.port}";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
        };
      };

      networking.firewall.allowedTCPPorts = lib.mkIf (cfg.vhost != null) [
        80
        443
      ];
    })
  ];
}
