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

  # Hermes discovers user memory providers at $HERMES_HOME/plugins/<name>/
  # (directory scan, not entry points), and the plugin imports both packages
  # absolutely, so both must live in hermes-agent's site-packages.
  hermesAgent = inputs.llm-agents.packages.${pkgs.system}.hermes-agent.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ [
      mnemosyne
      mnemosyne-hermes
    ];
  });
in
{
  services.hermes-webui.agentPackage = lib.mkForce hermesAgent;

  # MnemosyneMemoryProvider plugin dir; the package directory IS the plugin.
  home.file.".hermes/plugins/mnemosyne" = {
    source = "${mnemosyne-hermes}/${python.sitePackages}/mnemosyne_hermes";
  };

  home.packages = [ mnemosyne ];
}
