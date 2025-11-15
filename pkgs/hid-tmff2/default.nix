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
