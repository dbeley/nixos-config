{ lib, user, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    defaultNetwork.settings.dns_enabled = true;
  };
  users.users.${user} = {
    extraGroups = lib.mkMerge [[ "podman" ]];
  };
}
