# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c61e5771-e59b-4ae7-aee7-9275a5ee4a1a";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-60526d68-4044-45d8-82a7-0e1a26656183".device = "/dev/disk/by-uuid/60526d68-4044-45d8-82a7-0e1a26656183";
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/7A68-2FAE";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp58s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
