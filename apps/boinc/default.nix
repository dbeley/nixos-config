{
  config,
  lib,
  pkgs,
  user,
  ...
}:
{
  services.boinc = {
    enable = true;
    allowRemoteGuiRpc = true;
    extraEnvPackages =
      with pkgs;
      [
        ocl-icd
      ];
  };

  users.users.boinc.extraGroups = [ "video" "render" ];

  environment.systemPackages = [
    pkgs.boinc
    pkgs.boinctui
  ];

  users.users.${user}.extraGroups = lib.mkAfter [ "boinc" ];

  networking.firewall.allowedTCPPorts =
    lib.optionals config.services.boinc.allowRemoteGuiRpc [ 31416 ];
}
