{ inputs, pkgs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.system};

  hermes-webui = pkgs.stdenv.mkDerivation {
    pname = "hermes-webui";
    version = "0.51.210";

    src = pkgs.fetchFromGitHub {
      owner = "nesquena";
      repo = "hermes-webui";
      rev = "4baa26bb5b79dab38134eb1695f7b3d3b1e87831";
      hash = "sha256-uISUdi54C32XpjmP397u1Tzcoo1pN3TdUbdpO6VuRJc=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{bin,share/hermes-webui}
      cp -r api static server.py bootstrap.py requirements.txt $out/share/hermes-webui/
      makeWrapper ${hermes-webui-python}/bin/python3 $out/bin/hermes-webui \
        --add-flags "$out/share/hermes-webui/server.py" \
        --chdir "$out/share/hermes-webui"
      runHook postInstall
    '';
  };

  hermes-webui-python = pkgs.python3.withPackages (ps: [
    ps.pyyaml
    ps.cryptography
  ]);
in
{
  home.packages = [ llm.hermes-agent ];

  systemd.user.services.hermes-gateway = {
    Unit = {
      Description = "Hermes Gateway (cron jobs, messaging)";
      After = [ "network.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Environment = [
        "PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:%h/.nix-profile/bin"
      ];
      ExecStart = "${llm.hermes-agent}/bin/hermes gateway run";
      Restart = "always";
      RestartSec = 10;
    };
  };

  systemd.user.services.hermes-webui = {
    Unit = {
      Description = "Hermes WebUI";
      After = [ "network.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Environment = [
        "HERMES_WEBUI_HOST=0.0.0.0"
        "HERMES_WEBUI_PORT=8787"
        "HERMES_WEBUI_AGENT_DIR=${llm.hermes-agent.src}"
        "PYTHONPATH=${llm.hermes-agent.src}"
        "PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:%h/.nix-profile/bin"
      ];
      ExecStart =
        let
          startScript = pkgs.writeShellScript "hermes-webui-start" ''
            if [ -f "$HOME/.config/hermes/webui-password" ]; then
              export HERMES_WEBUI_PASSWORD=$(< "$HOME/.config/hermes/webui-password")
            fi
            HERMES_PYTHON=$(grep -oP "HERMES_PYTHON='\K[^']+" ${llm.hermes-agent}/bin/hermes 2>/dev/null || true)
            if [ -n "$HERMES_PYTHON" ] && [ -x "$HERMES_PYTHON" ]; then
              cd ${hermes-webui}/share/hermes-webui
              exec "$HERMES_PYTHON" server.py
            else
              exec ${hermes-webui}/bin/hermes-webui
            fi
          '';
        in
        "${startScript}";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
