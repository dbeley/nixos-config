{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    beets
    btop-rocm
    borgbackup
    borgmatic
    heroic
    musescore
    nautilus
    shotcut
    supersonic
    # xfce.thunar
    # xfce.tumbler

    discord
  ];
}
