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
    version =
      let
        m = builtins.match ".*__version__ = \"([^\"]+)\".*" (
          builtins.readFile "${inputs.mnemosyne}/mnemosyne/__init__.py"
        );
      in
      if m == null then
        throw "cannot extract mnemosyne-memory version from mnemosyne input"
      else
        builtins.head m;
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
    version =
      let
        m = builtins.match ".*name = \"mnemosyne-hermes\"\nversion = \"([^\"]+)\".*" (
          builtins.readFile "${inputs.mnemosyne}/integrations/hermes/pyproject.toml"
        );
      in
      if m == null then
        throw "cannot extract mnemosyne-hermes version from mnemosyne input"
      else
        builtins.head m;
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
