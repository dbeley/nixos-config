{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  python = pkgs.python3;

  mnemosyne = python.pkgs.buildPythonPackage {
    pname = "mnemosyne-memory";
    version = "3.16.0";
    src = inputs.mnemosyne;
    pyproject = true;

    build-system = with python.pkgs; [
      setuptools
      wheel
    ];

    dependencies = with python.pkgs; [
      pyyaml
      fastembed
      sqlite-vec
    ];

    doCheck = false;
  };

  mnemosyne-hermes = python.pkgs.buildPythonPackage {
    pname = "mnemosyne-hermes";
    version = "0.6.0";
    src = inputs.mnemosyne;
    pyproject = true;

    postUnpack = ''
      sourceRoot="$sourceRoot/integrations/hermes"
    '';

    build-system = with python.pkgs; [
      setuptools
    ];

    dependencies = [
      mnemosyne
    ];

    doCheck = false;
  };
in
{
  # Expose the mnemosyne packages to the agent's Python environment via the
  # home-manager module's new extraPythonPackages option.  This ensures that
  # mnemosyne and sqlite-vec are importable by the gateway process at runtime,
  # so the Mnemosyne memory plugin can load its tools and prefetch memories.
  services.hermes-webui.extraPythonPackages = [
    mnemosyne
    mnemosyne-hermes
  ];

  # MnemosyneMemoryProvider plugin dir; the package directory IS the plugin.
  home.file.".hermes/plugins/mnemosyne" = {
    source = "${mnemosyne-hermes}/${python.sitePackages}/mnemosyne_hermes";
  };

  home.packages = [ mnemosyne ];
}
