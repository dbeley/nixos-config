{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    audacity
    backrest
    beets
    discord
    feishin
    heroic
    musescore
    nautilus
    python313Packages.subliminal
    shotcut
    # supersonic
  ];

  programs.btop.package = pkgs.btop-rocm;
}
