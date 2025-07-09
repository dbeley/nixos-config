{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    beets
    nautilus
    supersonic
  ];
}
