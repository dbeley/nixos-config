{
  lib,
  modulesPath,
  ...
}:

# This host is a Proxmox/Kimsufi guest installed with scripts/install-nixos.sh,
# which labels its filesystems (boot, nixos, swap) instead of relying on a
# UUID we cannot know before the install. Re-generating this file by hand with
# `nixos-generate-config` would replace the labels with UUIDs; either form
# works, only keep one of them per host.
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "ext4";
    };
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  services.qemuGuest.enable = true;
}
