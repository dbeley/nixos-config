{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    backrest
    beets
    btop-rocm
    discord
    heroic
    musescore
    nautilus
    shotcut
    supersonic
  ];
}
