{ lib, modulesPath, ... }:
{
  boot = {
    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
      "sd_mod"
      "sr_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7dab74fd-37a0-4c8f-8e2e-baad05fad55e";
    fsType = "ext4";
  };
  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
