{ lib, ... }:
{
  boot = {
    kernel.sysctl = {
      "vm.swappiness" = lib.mkForce 100;
      "vm.dirty_ratio" = lib.mkForce 10;
      "vm.dirty_background_ratio" = lib.mkForce 5;
      "vm.vfs_cache_pressure" = lib.mkForce 120;
    };
  };

  services.fwupd.enable = lib.mkForce false;
}
