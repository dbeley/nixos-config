# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{user, ...}: {
  imports = [
    ./disk-config.nix
  ];
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "era1-nixos";

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    #   font = "Lat2-Terminus16";
    keyMap = "us-acentos";
    #   useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };
  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOQDbMwmbs+6iRQacX0uBN6OLvvx4e6+rNNLXpXY90JtppH/OQsmTsXMvk5h38TGNn150/ZAcxbf27ppBgSBrDqwr2q5ja4EcB+OL3EdDiMPqamQVhaFyxzhlikyF9kbspRZi27IiFnquA8ju62HIDUnyk+PgLYa4s7sNTD/9L1FMtaFRkIT2wNiQuUuuyDTaeNafTWawQDzd04U4wLuQXLsOKndAVdvxHPXIFZAJA0nDfYJCc3naYKXPbtcwRGGVKzqdXc67p49HwC1fcD1yFLe5WrKL9Ft3tdAMdsY4Mn8y/oA1gvrxCfAVBRVeOmcfioKQEefB1gZOozpb5qskQNbkMmIyIgk4o+A1svT4Mp8rJ7HCpDDlV3okzRlAy2RWXZBvwHqKTqmjS9eLQTrM+PS5vbYpdMasIitSqAxKq0InM8GH0BgkgckQJQmPchVv9L0xwEoi6wdohB5wuWNOJnvRZKyHZ+CxIa3Wwz/aRuPHvleFl8MmpjgyFYOF58bE90LvZiwfy5QUEZlY//TkjDhr8SKKnds/oxuYdI79AJeo7QScTjdYhPpk7PpcFYMdJgCOZqnhJo95N52iJ26NC7hSi1m4dj3330fbyvjY5pDHw5yl26hkv/tiW3fbHAv9am8CJaNUIjPg7+TGSI2Ts5ryYHrNRpkLhx2Is2XOtAQ== dddd@netc.fr"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
