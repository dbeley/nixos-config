{
  lib,
  pkgs,
  ...
}:
{
  hardware.mnt-pocket-reform = {
    enable = true;

    power = {
      cmaSize = "128MB";
      nvmePsMaxLatencyUs = 100000;
      pcieAspm = null;
      pcieAspmPolicy = "powersave";
    };

    initrd = {
      luks = false;
      btrfs = false;
    };
  };

  boot = {
    tmp.useTmpfs = lib.mkForce false;

    kernelParams = [ "fbcon=rotate:3" ];

    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.page-cluster" = 0;

      "vm.min_free_kbytes" = 32768;
      "vm.vfs_cache_pressure" = 50;
      "vm.watermark_scale_factor" = 125;
      "vm.watermark_boost_factor" = 0;

      "vm.dirty_background_bytes" = 33554432; # 32 MiB
      "vm.dirty_bytes" = 201326592; # 192 MiB
      "vm.dirty_expire_centisecs" = 1500;

      "kernel.numa_balancing" = 0;
      "vm.compaction_proactiveness" = 0;
    };
  };

  zramSwap.memoryPercent = lib.mkForce 50;

  services = {
    fprintd.enable = lib.mkForce false;
    blueman.enable = lib.mkForce false;
  };

  systemd.services.fprintd.enable = lib.mkForce false;

  nix = {
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;
    settings.max-jobs = 2;
  };
  systemd.services.nix-daemon.serviceConfig.Nice = 10;

  environment.systemPackages = with pkgs; [
    alsa-utils
    usbutils
    pciutils
    iw
    tcpdump
    lm_sensors
  ];
}
