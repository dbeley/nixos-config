{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # The NVMe root is declared by hosts/pocket-reform/disko.nix (plain ext4,
  # no LUKS, no impermanence). /boot lives on the microSD card because the
  # Pocket Reform U-Boot does not scan the NVMe.
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXOS_BOOT";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  swapDevices = [ ];
}
