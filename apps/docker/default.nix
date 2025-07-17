{ lib, user, ... }:
{
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };
  users.users.${user}.extraGroups = lib.mkMerge [[ "docker" ]];
}
