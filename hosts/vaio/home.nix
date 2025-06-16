{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    beets
    nautilus
    supersonic
  ];
}
