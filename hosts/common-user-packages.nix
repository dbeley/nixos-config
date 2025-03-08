{ pkgs, ... }:
{
  home.packages = with pkgs; [
    btop
    eza
    fd
    ffmpeg
    ffmpegthumbnailer
    gnome-system-monitor
    htop
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
}
