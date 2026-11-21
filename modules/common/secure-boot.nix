{ pkgs, lib, ... }:
{
  environment.systemPackages = [ pkgs.sbctl ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.loader.limine = {
    enable = true;
    enableEditor = false;
    maxGenerations = 3;
    secureBoot = {
      enable = true;
      # The first install runs limine-install from nixos-install, where no
      # keys exist yet. Generate them there instead of failing; the keys are
      # copied onto /persistent by scripts/post-install-disko.sh. Enrolling
      # them in firmware (sbctl enroll-keys, setup mode) stays manual.
      autoGenerateKeys = true;
    };
  };
}
