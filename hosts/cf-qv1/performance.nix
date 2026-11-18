{
  config,
  pkgs,
  ...
}:
let
  # Panasonic's DPTF firmware exposes the EC power cap as an ACPI toggle:
  #   \_SB.PC00.LPCB.EC0.SEPL(1) -> EPLE=1 -> REPL() applies P140/P143  (capped, ~10 W)
  #   \_SB.PC00.LPCB.EC0.SEPL(0) -> EPLE=0 -> REPL() writes 0xFF        (uncapped)
  #
  # The firmware only lifts the cap when an OS claims the DPTF root device
  # (\_SB.IETM, HID INTC1040) and its _OSC negotiates capability bits 0x02/0x04.
  # No Linux driver binds INTC1040, so the capped default always wins.
  tdpScript = pkgs.writeShellScript "cf-qv1-tdp" ''
    set -eu
    [ -w /proc/acpi/call ] || exit 0
    if [ "$(cat /sys/class/power_supply/AC/online 2>/dev/null || echo 0)" = "1" ]; then
      printf '\\_SB.PC00.LPCB.EC0.SEPL (0)' > /proc/acpi/call
    else
      printf '\\_SB.PC00.LPCB.EC0.SEPL (1)' > /proc/acpi/call
    fi
    exit 0
  '';
in
{
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
    kernelModules = [ "acpi_call" ];
  };

  systemd.services.cf-qv1-tdp = {
    description = "Lift the Panasonic EC power cap while on AC";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = tdpScript;
    };
  };
}
