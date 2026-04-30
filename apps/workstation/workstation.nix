{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brightnessctl
    ffmpegthumbnailer
    gh
    # gnome-system-monitor
    imagemagick
    just
    keepassxc
    libreoffice-fresh
    pwvucontrol
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
