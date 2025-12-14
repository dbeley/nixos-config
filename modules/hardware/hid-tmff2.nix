{
  lib,
  config,
  pkgs,
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
      version = "unstable-2025-11-07";

      src = fetchFromGitHub {
        owner = "Kimplul";
        repo = "hid-tmff2";
        rev = "2a7b3568792d50e94479298b5d0e5602d4e230f8";
        sha256 = "sha256-NcIQ0rW7ZPujq7MRMYW0sQ4qWRwhLnovHDqzzxkwtwY=";
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
        udevRules = "${finalAttrs.src}/udev/99-thrustmaster.rules";
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
      boot = {
        extraModulePackages = [ cfg.package ];
        kernelModules = [ "hid-tmff-new" ];
        blacklistedKernelModules = lib.optionals cfg.blacklistHidThrustmaster [ "hid_thrustmaster" ];
      };

      services.udev.extraRules = lib.mkAfter (
        patchedRules
        + ''
          KERNEL=="hidraw*", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b696", MODE="0666"
        ''
      );
    }
  );
}
