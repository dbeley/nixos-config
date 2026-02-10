{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    backrest
    beets
    btop-rocm
    borgbackup
    borgmatic
    feishin
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
