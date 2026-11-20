{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    openttd
    simutrans
    cataclysm-dda
    openarena
    urbanterror
    # assaultcube
    # sauerbraten
    openrct2
    openra
    uqm
    freeciv
    # hedgewars
    wesnoth
    endless-sky
    # dwarf-fortress-full
  ];
}
