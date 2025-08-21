{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # audacity
    beets
    # musescore
    nautilus
    # shotcut
    supersonic
  ];

}
