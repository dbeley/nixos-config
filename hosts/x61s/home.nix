{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    beets
    borgbackup
    borgmatic
    supersonic
    xfce.thunar
    xfce.tumbler
  ];
}
