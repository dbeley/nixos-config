{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # audacity
    # beets
    # borgbackup
    # borgmatic
    # discord
    # heroic
    # itch
    # musescore
    nautilus
    # shotcut
    # supersonic
  ];
}
