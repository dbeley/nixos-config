{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    beets
    borgbackup
    borgmatic
    # fio
    # gh
    # gthumb
    # hugo
    supersonic
    xfce.thunar
    xfce.tumbler

    # discord
    # element-desktop

    # dev dependencies
    # clang
    # gnumake
    # cmake
    # libtool
  ];
}
