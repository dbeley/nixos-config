{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hardware.hid-tmff2;
in
{
  options.hardware.hid-tmff2 = {
    enable = lib.mkEnableOption "the hid-tmff2 kernel module for Thrustmaster wheels";

    package = lib.mkOption {
      type = lib.types.package;
      default = config.boot.kernelPackages.callPackage ../../pkgs/hid-tmff2 { };
      defaultText = "config.boot.kernelPackages.callPackage ../../pkgs/hid-tmff2 { }";
      description = "hid-tmff2 kernel module package to install.";
    };

    blacklistHidThrustmaster = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to blacklist the upstream hid_thrustmaster module to avoid conflicts.";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      # Upstream rules expect FHS paths; rewrite them to point to nixpkgs binaries.
      patchedRules =
        lib.replaceStrings
          [
            "/usr/bin/evdev-joystick"
            "/usr/bin/jscal"
          ]
          [
            "${pkgs.linuxConsoleTools}/bin/evdev-joystick"
            "${pkgs.linuxConsoleTools}/bin/jscal"
          ]
          (builtins.readFile cfg.package.passthru.udevRules);
    in
    {
      boot.extraModulePackages = [ cfg.package ];
      boot.kernelModules = [ "hid-tmff-new" ];
      boot.blacklistedKernelModules = lib.optionals cfg.blacklistHidThrustmaster [ "hid_thrustmaster" ];

      services.udev.extraRules = lib.mkAfter patchedRules;
    }
  );
}
