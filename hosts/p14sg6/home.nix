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
    llmfit
    musescore
    nautilus
    python313Packages.subliminal
    shotcut
    # supersonic
  ];
}
