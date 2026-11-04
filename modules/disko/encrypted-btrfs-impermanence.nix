{
  hostName,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.disko.nixosModules.disko ];
  options = {
    disko.mainDisk = lib.mkOption {
      type = lib.types.str;
      default = "/dev/nvme0n1";
      description = "Main disk device for disko partitioning. Override this for different hardware configurations. Use `lsblk` to identify the correct device.";
    };
    disko.withBootPartition = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether disko should create and mount a dedicated /boot partition on
        the main disk. Set to false when /boot lives on another device (for
        example the microSD card on the MNT Pocket Reform).
      '';
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
            partitions = lib.mkMerge [
              (lib.mkIf config.disko.withBootPartition {
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
              })
              {
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
                          mountOptions = [
                            "compress=zstd"
                            "noatime"
                          ];
                        };
                        "/persistent" = {
                          mountpoint = "/persistent";
                          mountOptions = [
                            "compress=zstd"
                            "noatime"
                          ];
                        };
                        "/nix" = {
                          mountpoint = "/nix";
                          mountOptions = [
                            "compress=zstd"
                            "noatime"
                          ];
                        };
                      };
                    };
                  };
                };
              }
            ];
          };
        };
      };
    };
  };
}
