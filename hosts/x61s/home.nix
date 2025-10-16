{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    beets
    btop
    borgbackup
    borgmatic
    supersonic
    xfce.thunar
    xfce.tumbler
  ];
}
