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
    device = "/dev/disk/by-uuid/d8d88e75-0e97-47c5-bfdc-011a77ec1d12";
    fsType = "ext4";
  };
  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
