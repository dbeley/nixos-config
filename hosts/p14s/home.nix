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
    heroic
    nautilus
    shotcut
    supersonic
    # xfce.thunar
    # xfce.tumbler

    discord
  ];
}
