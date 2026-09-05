# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  lib,
  user,
  hostName,
  stateVersion,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.useTmpfs = true;
  };

  networking = {
    inherit hostName;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    firewall.enable = lib.mkDefault true;
  };

  systemd.services.NetworkManager.after = [ "iwd.service" ];
  systemd.services.NetworkManager.wants = [ "iwd.service" ];

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services = {
    resolved = {
      enable = true;
      settings.Resolve = {
        DNS = [
          "9.9.9.9#dns.quad9.net"
          "149.112.112.112#dns.quad9.net"
        ];
        FallbackDNS = [
          "1.1.1.1#cloudflare-dns.com"
          "1.0.0.1#cloudflare-dns.com"
          "8.8.8.8#dns.google"
        ];
        DNSOverTLS = "opportunistic";
        DNSSEC = "allow-downgrade";
      };
    };

    printing.enable = lib.mkDefault false;
    fstrim.enable = true;
    journald.settings.Journal = {
      SystemMaxUse = "50M";
      SystemMaxFileSize = "10M";
      RuntimeMaxUse = "50M";
      RuntimeMaxFileSize = "10M";
    };
  };

  security = {
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      extraConfig = ''
        Defaults timestamp_timeout=30
        # Defaults timestamp_type=global
      '';
    };
  };

  users.mutableUsers = lib.mkDefault true;
  users.users.${user} = {
    isNormalUser = true;
    description = (lib.toUpper (lib.substring 0 1 user)) + (lib.substring 1 (-1) user);
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      chromium.enableWideVine = true;
    };
  };

  environment.systemPackages = with pkgs; [
    nfs-utils
  ];

  programs = {
    nix-ld.enable = true;
    command-not-found.enable = false;
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 3";
      };
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      keep-outputs = true;
      keep-derivations = true;
      trusted-users = [
        "root"
        user
      ];
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
      auto-optimise-store = true;
      warn-dirty = false;
      fallback = true;
      connect-timeout = 10;
      download-attempts = 3;
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    channel.enable = false;
  };

  environment.etc."nix/inputs/nixpkgs".source = inputs.nixpkgs;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 200;
  };

  # BBR congestion control: lower latency and better throughput than cubic
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";

    # Kernel information-leak and introspection restrictions
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.yama.ptrace_scope" = 2;
    "kernel.sysrq" = 0;
    "kernel.perf_event_paranoid" = 3;

    # Filesystem protections
    "fs.protected_symlinks" = 1;
    "fs.protected_hardlinks" = 1;
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;

    # Network hardening
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.log_martians" = true;
    "net.ipv4.conf.default.log_martians" = true;
    "net.ipv4.conf.all.accept_redirects" = false;
    "net.ipv4.conf.all.secure_redirects" = false;
    "net.ipv4.conf.default.accept_redirects" = false;
    "net.ipv4.conf.default.secure_redirects" = false;
    "net.ipv6.conf.all.accept_redirects" = false;
    "net.ipv6.conf.default.accept_redirects" = false;
    "net.ipv4.conf.all.send_redirects" = false;
    "net.ipv4.conf.default.send_redirects" = false;
    "net.ipv4.tcp_rfc1337" = true;
  };

  boot.blacklistedKernelModules = [
    # Obscure networking protocols
    "ax25"
    "netrom"
    "rose"
    "decnet"
    "econet"
    "af_802154"
    "ipx"
    "appletalk"
    "psnap"
    "p8023"
    "p8022"
    "dccp"
    "sctp"
    "rds"
    "tipc"
    # Rare filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "freevxfs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];

  boot.kernelParams = [
    # Exploit mitigations with a modest memory/boot-time cost.
    "slab_nomerge"
    "init_on_alloc=1"
    "page_alloc.shuffle=1"
    "randomize_kstack_offset=on"
    "vsyscall=none"
    "debugfs=off"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = stateVersion; # Did you read the comment?
}
