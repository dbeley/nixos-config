{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hardware.hid-tmff2;

  # nixpkgs' derivation is still on an older upstream revision; override just
  # the source to keep the more recent force-feedback precision fixes.
  hidTmff2Package = config.boot.kernelPackages.hid-tmff2.overrideAttrs (_old: {
    version = "unstable-2026-08-25";
    src = pkgs.fetchFromGitHub {
      owner = "Kimplul";
      repo = "hid-tmff2";
      rev = "d890a93105a0aa52028ac49282fa1b579e12566e";
      hash = "sha256-+fK+rCvlZyDxxcuwGkq8KmhK2C5eHu4atBmdpsaIfRo=";
      fetchSubmodules = true;
    };
  });
in
{
  options.hardware.hid-tmff2 = {
    enable = lib.mkEnableOption "the hid-tmff2 kernel module for Thrustmaster wheels";

    package = lib.mkOption {
      type = lib.types.package;
      default = hidTmff2Package;
      defaultText = lib.literalExpression "hidTmff2Package";
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
      udevRules = builtins.readFile "${cfg.package.src}/udev/71-thrustmaster-steamdeck.rules";
    in
    {
      boot = {
        extraModulePackages = [ cfg.package ];
        kernelModules = [ "hid-tmff-new" ];
        blacklistedKernelModules = lib.optionals cfg.blacklistHidThrustmaster [ "hid_thrustmaster" ];
      };

      services.udev.extraRules = lib.mkAfter (
        udevRules
        + ''
          KERNEL=="hidraw*", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b696", MODE="0666"
        ''
      );
    }
  );
}
