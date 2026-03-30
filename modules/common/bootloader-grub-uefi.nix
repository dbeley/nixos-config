{
  # Bootloader.
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        configurationLimit = 10;
      };
    };
  };
}
