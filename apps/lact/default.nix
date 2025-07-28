{ config, pkgs, lib, ... }:

let
  cfg = config.my.lact;
  lactConfig = pkgs.writeText "lact-config.yaml" ''
    daemon:
      admin_group: wheel
    apply_settings_timer: 5
    gpus:
      ${cfg.gpuId}:
        max_voltage: ${toString cfg.maxVoltage}
  '';
in {
  options.my.lact = {
    enable = lib.mkEnableOption "LACT daemon";
    gpuId = lib.mkOption {
      type = lib.types.str;
      description = "GPU identifier as reported by `lact cli list-gpus`";
    };
    maxVoltage = lib.mkOption {
      type = lib.types.int;
      default = 1000;
      description = "Maximum GPU voltage in mV";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.lact ];

    environment.etc."lact/config.yaml".source = lactConfig;

    systemd.services.lactd = {
      description = "LACT GPU control daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "graphical.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lactd --config /etc/lact/config.yaml";
        Restart = "on-failure";
      };
    };
  };
}
