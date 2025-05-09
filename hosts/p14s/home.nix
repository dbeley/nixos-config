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
    shotcut
    supersonic
    xfce.thunar
    xfce.tumbler

    discord
  ];
}
