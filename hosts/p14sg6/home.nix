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
    feishin
    heroic
    musescore
    nautilus
    shotcut
    # supersonic
  ];
}
