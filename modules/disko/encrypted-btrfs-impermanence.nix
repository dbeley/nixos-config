{
  hostName,
  lib,
  config,
  ...
}:
let
  btrfsMountOptions = [
    "compress=zstd"
    "noatime"
  ];
in
{
  options = {
    disko.mainDisk = lib.mkOption {
      type = lib.types.str;
      default = "/dev/nvme0n1";
      description = "Main disk device for disko partitioning. Override this for different hardware configurations. Use `lsblk` to identify the correct device.";
    };
  };

  config = {
    boot.supportedFilesystems = [ "btrfs" ];
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = config.disko.mainDisk;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "root_vg_${hostName}";
                  settings = {
                    allowDiscards = true;
                  };
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                        inherit btrfsMountOptions;
                      };
                      "/persistent" = {
                        mountpoint = "/persistent";
                        inherit btrfsMountOptions;
                      };
                      "/nix" = {
                        mountpoint = "/nix";
                        inherit btrfsMountOptions;
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
