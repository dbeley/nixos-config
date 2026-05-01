{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brightnessctl
    ffmpeg
    ffmpegthumbnailer
    gh
    # gnome-system-monitor
    # htop
    imagemagick
    just
    keepassxc
    libreoffice-fresh
    nitch
    nix-tree
    pwvucontrol
    ripgrep-all
    unzip
    wireguard-tools
    yt-dlp
  ];

  # dconf = {
  #   enable = true;
  #   settings = {
  #     "org/gnome/gnome-system-monitor" = {
  #       graph-update-interval = 2000;
  #       graph-data-points = 600;
  #       update-interval = 5000;
  #       disks-interval = 10000;
  #     };
  #   };
  # };

  services.mpris-proxy.enable = true;
}
