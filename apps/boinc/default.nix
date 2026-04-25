{
  lib,
  pkgs,
  user,
  ...
}:
let
  boinc-wrapped = pkgs.symlinkJoin {
    name = "boinc-wrapped";
    paths = [ pkgs.boinc ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      # Force boincmgr to run under XWayland to avoid Wayland protocol errors.
      wrapProgram $out/bin/boincmgr --set GDK_BACKEND x11
    '';
  };
in
{
  services.boinc = {
    enable = true;
    package = boinc-wrapped;
    allowRemoteGuiRpc = false;
    extraEnvPackages = with pkgs; [
      ocl-icd
    ];
  };

  users.users.boinc.extraGroups = [
    "video"
    "render"
  ];

  environment.systemPackages = [
    boinc-wrapped
    pkgs.boinctui
  ];

  users.users.${user}.extraGroups = lib.mkAfter [ "boinc" ];
}
