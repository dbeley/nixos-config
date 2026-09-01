{
  pkgs,
  ...
}:
# Fix for the Panasonic CF-QV1 ACPI BIOS error about missing DPP1-DPP3
# symbols seen on every boot:
#
#   ACPI BIOS Error (bug): Could not resolve symbol
#     [\_SB.PC00.I2C1.PA01._STA.DPP1], AE_NOT_FOUND
#
# Root cause: the firmware DSDT declares DPP1-DPP5 as External methods and
# calls them from the _STA methods of the MCHP1930 (Microchip PAC1934)
# power-monitor devices under \_SB.PC00.I2C1.PA01-PA03, but no firmware
# SSDT ever defines them. `CondRefOf (DPP1)` succeeds against the external
# stub, then `DPP1 ()` aborts with AE_NOT_FOUND, aborting the whole _STA.
#
# The firmware intends the devices to report present when DPPx() returns
# TRUE, so we inject a small SSDT (OEM table ID "DppFix", which matches no
# firmware table and therefore gets *appended* to the RSDT) defining the
# five methods as returning One. The kernel's initrd ACPI table override
# mechanism (CONFIG_ACPI_TABLE_UPGRADE) loads it before device probing.
let
  table = pkgs.runCommandLocal "cf-qv1-dpp-fix.aml" { } ''
    cp ${./dpp-fix.aml} $out
  '';
in
{
  # cf-qv1 boots systemd-based stage-1 initrd; files must be added via
  # boot.initrd.systemd.contents.
  boot.initrd.systemd.contents = {
    "/kernel/firmware/acpi/SSDT1.aml".source = table;
  };
}
