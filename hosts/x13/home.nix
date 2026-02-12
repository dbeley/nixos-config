{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    beets
    btop
    borgbackup
    borgmatic
    discord
    heroic
    itch
    musescore
    nautilus
    shotcut
    # supersonic
  ];
}
