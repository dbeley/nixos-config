{
  lib,
  pkgs,
  ...
}:
let
  gpuPowerLimitWatts = 180;
  pptLimitWatts = 88;
  tdcLimitAmps = 60;
  edcLimitAmps = 90;

  nvidiaPowerLimitScript = pkgs.writeShellScript "sg13-nvidia-power-limit" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    if [ ! -x /run/current-system/sw/bin/nvidia-smi ]; then
      exit 0
    fi

    # Give the NVIDIA persistence daemon a moment to come up before we try to
    # change power management settings so that the command does not fail when
    # the driver is still initialising at boot.
    for attempt in 1 2 3 4 5; do
      if /run/current-system/sw/bin/nvidia-smi -pm 1; then
        break
      fi
      if [ "${attempt}" -eq 5 ]; then
        exit 1
      fi
      sleep 2
    done

    /run/current-system/sw/bin/nvidia-smi -pl ${toString gpuPowerLimitWatts}
  '';

  ryzenEcoScript = pkgs.writeShellScript "sg13-ryzen-eco" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    ${lib.getExe pkgs.ryzenadj} \
      --ppt-limit=${toString pptLimitWatts} \
      --tdc-limit=${toString tdcLimitAmps} \
      --edc-limit=${toString edcLimitAmps} \
      --coall=-15
  '';

in
{
  environment.systemPackages = [ pkgs.ryzenadj ];

  boot.kernelModules = [ "msr" ];

  systemd.services.sg13-nvidia-power-limit = {
    description = "Set NVIDIA GPU power limit for sg13";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = nvidiaPowerLimitScript;
      RemainAfterExit = true;
    };
  };

  systemd.services.sg13-ryzen-eco = {
    description = "Apply Ryzen 5950X eco tuning";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ryzenEcoScript;
      RemainAfterExit = true;
    };
  };
}
