{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brightnessctl
    ffmpegthumbnailer
    gh
    gnome-system-monitor
    imagemagick
    just
    keepassxc
    libreoffice-fresh
    pavucontrol
    yt-dlp
  ];
}
