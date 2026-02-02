{
  modulesPath,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  environment.systemPackages = with pkgs; [
    git
    helix
    btop
    tmux
    wget
    curl
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  networking = {
    wireless.enable = lib.mkForce false;
    networkmanager = {
      enable = lib.mkForce true;
      wifi.backend = lib.mkForce "iwd";
    };
  };

  users.users.nixos.password = "nixos";
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "75%";
  };

  console = {
    font = "ter-v24n";
    packages = [ pkgs.terminus_font ];
  };

  environment.etc."issue".text = ''

    NixOS Config Installer
    ======================

    To install with disko (for impermanence hosts):
      sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake /etc/iso-config#HOSTNAME --disk main /dev/DEVICE

    To install traditionally:
      sudo nixos-install --flake /etc/iso-config#HOSTNAME

    Useful commands:
      nix flake show /etc/iso-config        # List all hosts
      lsblk                                 # List disks
      nmtui                                 # Configure WiFi

    Login credentials:
      username: nixos
      password: nixos

  '';
}
