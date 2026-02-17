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
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    inherit hostName;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    firewall.enable = lib.mkDefault false;
  };

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

  # Configure console keymap
  console.keyMap = "us-acentos";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable sound with pipewire.
  services = {
    fwupd.enable = true;
    resolved.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      wireplumber.extraConfig.wireplumber-disable-camera = {
        "wireplumber.profiles" = {
          "monitor.libcamera" = "disabled";
        };
      };
    };

    printing.enable = lib.mkDefault false;
    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = true;
    };
    fstrim.enable = true;
    journald.extraConfig = ''
      SystemMaxUse=50M
      SystemMaxFileSize=10M
      RuntimeMaxUse=50M
      RuntimeMaxFileSize=10M
    '';

    gvfs.enable = true;
  };

  security = {
    rtkit.enable = true;
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
    description = user;
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
    overlays = [ inputs.nur.overlays.default ];
  };

  environment.systemPackages = with pkgs; [
    git
    killall
    nfs-utils
    wireguard-tools
  ];

  programs.command-not-found.enable = false;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
  };

  fonts = {
    # Now handled by stylix except noto-fonts for emojis and special characters
    packages = with pkgs; [
      #   nerd-fonts.iosevka
      #   eb-garamond
      #   liberation_ttf
      #   overpass
      noto-fonts
      noto-fonts-cjk-sans
      #   noto-fonts-color-emoji
    ];
    fontconfig = {
      enable = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      keep-outputs = true;
      keep-derivations = true;
      substituters = [
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-users = [
        "root"
        user
      ];
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
      auto-optimise-store = true;
    };
    gc = {
      automatic = false;
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    channel.enable = false;
  };

  environment.etc."nix/inputs/nixpkgs".source = inputs.nixpkgs;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = stateVersion; # Did you read the comment?
}
