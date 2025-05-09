{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    beets
    # borgbackup
    # borgmatic
    # claude-code
    discord
    heroic
    itch
    musescore
    nautilus
    shotcut
    supersonic
  ];
}
