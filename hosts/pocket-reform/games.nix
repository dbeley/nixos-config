{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    openttd
    simutrans
    cataclysm-dda
  ];
}
