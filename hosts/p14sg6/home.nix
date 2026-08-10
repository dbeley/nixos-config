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
    jellyfin-media-player
    # musescore
    nautilus
    python3Packages.subliminal
    # shotcut
  ];

  programs.btop.package = pkgs.btop-rocm;
}
