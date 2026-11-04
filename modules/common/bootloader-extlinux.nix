{ lib, ... }:
{
  # Generic extlinux bootloader for ARM boards whose U-Boot reads
  # /boot/extlinux/extlinux.conf (MNT Pocket Reform, etc.).
  boot.loader = {
    grub.enable = lib.mkForce false;
    systemd-boot.enable = lib.mkForce false;
    limine.enable = lib.mkForce false;
    efi.canTouchEfiVariables = lib.mkForce false;

    generic-extlinux-compatible.enable = lib.mkDefault true;
  };
}
