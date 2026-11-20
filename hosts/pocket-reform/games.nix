{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    openttd
    simutrans
    cataclysm-dda
  ];
}
