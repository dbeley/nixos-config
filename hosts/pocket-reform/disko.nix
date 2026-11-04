{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.disko.nixosModules.disko ];

  options.disko.mainDisk = lib.mkOption {
    type = lib.types.str;
    default = "/dev/nvme0n1";
    description = "NVMe device used for the NixOS root filesystem.";
  };

  config = {
    # Simple unencrypted, mutable installation:
    #   NVMe p1 : ext4 -> /
    #   microSD : ext4 -> /boot
    #
    # No LUKS (no initrd passphrase, so no keyboard dependency) and no
    # impermanence (the root filesystem, /etc, /var and /home persist).
    disko.devices.disk.main = {
      type = "disk";
      device = config.disko.mainDisk;
      content = {
        type = "gpt";
        partitions.root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [ "noatime" ];
          };
        };
      };
    };
  };
}
