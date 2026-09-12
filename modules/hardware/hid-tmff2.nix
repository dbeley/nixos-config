{
  lib,
  config,
  ...
}:
let
  cfg = config.hardware.hid-tmff2;
  hidTmff2Package = config.boot.kernelPackages.callPackage (
    {
      lib,
      stdenv,
      fetchFromGitHub,
      kernel,
    }:
    let
      kdir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
      installDir = "kernel/drivers/hid";
    in
    stdenv.mkDerivation (finalAttrs: {
      pname = "hid-tmff2";
      version = "unstable-2026-08-25";

      src = fetchFromGitHub {
        owner = "Kimplul";
        repo = "hid-tmff2";
        rev = "d890a93105a0aa52028ac49282fa1b579e12566e";
        sha256 = "sha256-+fK+rCvlZyDxxcuwGkq8KmhK2C5eHu4atBmdpsaIfRo=";
        fetchSubmodules = true;
      };

      nativeBuildInputs = kernel.moduleBuildDependencies;

      buildPhase = ''
        runHook preBuild
        make KDIR=${kdir}
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        make -C deps/hid-tminit \
          KDIR=${kdir} \
          INSTALL_MOD_PATH=$out \
          INSTALL_MOD_DIR=${installDir} \
          install
        make -C ${kdir} \
          M=$PWD \
          INSTALL_MOD_PATH=$out \
          INSTALL_MOD_DIR=${installDir} \
          modules_install
        runHook postInstall
      '';

      passthru = {
        inherit (finalAttrs) src;
        udevRules = "${finalAttrs.src}/udev/71-thrustmaster-steamdeck.rules";
      };

      meta = with lib; {
        description = "Linux kernel module that improves force feedback for Thrustmaster wheels";
        homepage = "https://github.com/Kimplul/hid-tmff2";
        license = licenses.gpl3Plus;
        platforms = platforms.linux;
      };
    })
  ) { };
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
      udevRules = builtins.readFile cfg.package.passthru.udevRules;
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
