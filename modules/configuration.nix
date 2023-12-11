# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  user,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    extraGroups = ["networkmanager" "wheel" "video"];
    shell = "${pkgs.fish}/bin/fish";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.chromium.enableWideVine = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    killall
    nfs-utils
    wireguard-tools
    git
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Iosevka"];})
    eb-garamond
    liberation_ttf
    overpass
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];
  fonts.fontconfig.enable = true;

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

  # system = {
  #   autoUpgrade = {
  #     enable = true;
  #     channel = "https://nixos.org/channels/nixos-unstable";
  #     };
  #   };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = ["nixpkgs=/etc/channels/nixpkgs"];
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;

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
  system.stateVersion = "22.11"; # Did you read the comment?
}
