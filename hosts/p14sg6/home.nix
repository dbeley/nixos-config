{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # audacity
    backrest
    beets
    # discord
    feishin
    heroic
    # musescore
    nautilus
    python3Packages.subliminal
    # shotcut
    # supersonic
  ];

  programs.btop.package = pkgs.btop-rocm;
}
