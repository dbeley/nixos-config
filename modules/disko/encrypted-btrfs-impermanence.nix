{
  pkgs,
  hostName,
  ...
}:
{
  boot.supportedFilesystems = [ "btrfs" ];
  boot.initrd.systemd.enable = true;
  boot.initrd.extraUtilsCommands = ''
    copy_bin_and_libs ${pkgs.busybox}/bin/busybox
  '';
  boot.initrd.preLVMCommands = ''
    busybox --install -s
  '';
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
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
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "subvol=root"
                      ];
                    };
                    "/persistent" = {
                      mountpoint = "/persistent";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "subvol=persistent"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "subvol=nix"
                      ];
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
