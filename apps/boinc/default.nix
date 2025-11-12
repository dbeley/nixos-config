{
  config,
  lib,
  pkgs,
  user,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      boinc = prev.boinc.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ final.makeWrapper ];
        postInstall =
          (old.postInstall or "")
          + ''
            # Force boincmgr to run under XWayland to avoid Wayland protocol errors.
            wrapProgram $out/bin/boincmgr --set GDK_BACKEND x11
          '';
      });
    })
  ];

  services.boinc = {
    enable = true;
    allowRemoteGuiRpc = true;
    extraEnvPackages = with pkgs; [
      ocl-icd
    ];
  };

  users.users.boinc.extraGroups = [
    "video"
    "render"
  ];

  environment.systemPackages = [
    pkgs.boinc
    pkgs.boinctui
  ];

  users.users.${user}.extraGroups = lib.mkAfter [ "boinc" ];

  networking.firewall.allowedTCPPorts = lib.optionals config.services.boinc.allowRemoteGuiRpc [
    31416
  ];
}
