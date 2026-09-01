{
  # thermald is DISABLED on the Panasonic CF-QV1: its adaptive mode fails
  # every boot because the DSDT exposes no DPTF/PSVT zones for it to manage:
  #
  #   thermald: [WARN]Adaptive policy couldn't create any zones
  #   thermald: [WARN]Possibly some sensors in the PSVT are missing
  #   thermald.service: Failed with result 'exit-code'.
  #
  # Thermal management on this machine is handled by the Panasonic EC +
  # ACPI fan (acpi_fan), the Intel HWP internal throttling, and the kernel
  # thermal core (the only real trip point is acpitz critical@150°C, which
  # the kernel enforces natively). power-profiles-daemon (from
  # laptop.nix) manages the platform power profile. There are no passive
  # trip points left for thermald to enforce, so running it adds nothing
  # but a failed systemd unit every boot.
  services.thermald.enable = false;
}
