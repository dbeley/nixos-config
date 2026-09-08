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
    version = "4.0.0b1";
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
    version = "0.7.0";
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
  #
  # Backport of upstream hermes-agent 139396995 ("feat(opencode): send
  # x-opencode-session on every OpenCode request for backend affinity") onto
  # the pinned v2026.8.31 tag. OpenCode Go (opencode.ai/zen/go/v1) rejects
  # requests missing the header with HTTP 400; the fix only exists on
  # agent main (no release tag has it yet). Revisit once llm-agents.nix bumps
  # past v2026.8.31 and drop the patch (see ./opencode-session-affinity.patch).
  hermesAgent = inputs.llm-agents.packages.${pkgs.system}.hermes-agent.overridePythonAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./opencode-session-affinity.patch ];
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
