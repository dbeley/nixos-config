{ pkgs, lib, ... }:
{
  environment.systemPackages = [ pkgs.sbctl ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.loader.limine = {
    enable = true;
    enableEditor = false;
    maxGenerations = 3;
    secureBoot.enable = true;
  };
}
