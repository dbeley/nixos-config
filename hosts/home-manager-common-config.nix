{
  pkgs,
  user,
  stateVersion,
  ...
}:
{
  home = {
    username = user;
    homeDirectory = "/home/${user}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    inherit stateVersion;

    packages = with pkgs; [
      brightnessctl
      cachix
      eza
      fd
      ffmpeg
      ffmpegthumbnailer
      gnome-system-monitor
      htop
      imagemagick
      jq
      just
      keepassxc
      libreoffice-fresh
      ncdu
      nitch
      pavucontrol
      ripgrep
      ripgrep-all
      unzip
      yt-dlp
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.mpris-proxy.enable = true;

  dconf.settings = {
    "org/gnome/gnome-system-monitor" = {
      graph-update-interval = 1000;
      graph-data-points = 600;
      update-interval = 5000;
      disks-interval = 10000;
    };
  };
}
