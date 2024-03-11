# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, inputs, lib, user, hostName, stateVersion, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "${hostName}";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  networking.firewall.enable = true;

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

  # Enable sound with pipewire.
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  security.doas.enable = false;
  security.sudo.enable = true;
  # Configure doas
  security.doas.extraRules = [{
    users = [ "$user" ];
    keepEnv = true;
    persist = true;
  }];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "David";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = "${pkgs.fish}/bin/fish";
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    chromium.enableWideVine = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    killall
    nfs-utils
    wireguard-tools
    git
  ];

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
      eb-garamond
      liberation_ttf
      overpass
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
    fontconfig = { enable = true; };
  };

  services.printing.enable = false;
  services.gnome.gnome-keyring.enable = true;
  services.fstrim.enable = true;
  services.journald.extraConfig = ''
    SystemMaxUse=50M
    SystemMaxFileSize=10M
    RuntimeMaxUse=50M
    RuntimeMaxFileSize=10M
  '';

  services.gvfs.enable = true;
  # services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
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
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    channel.enable = false;
  };

  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

  # system.autoUpgrade = {
  #   enable = true;
  #   flake = inputs.self.outPath;
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "-L" # print build logs
  #   ];
  #   dates = "02:00";
  #   randomizedDelaySec = "45min";
  # };

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
  system.stateVersion = "${stateVersion}"; # Did you read the comment?
}
