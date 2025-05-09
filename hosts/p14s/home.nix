{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    beets
    borgbackup
    borgmatic
    # fio
    # gh
    # gthumb
    heroic
    # hugo
    shotcut
    supersonic
    xfce.thunar
    xfce.tumbler

    discord
    # element-desktop

    # dev dependencies
    # clang
    # gnumake
    # cmake
    # libtool
  ];
}
