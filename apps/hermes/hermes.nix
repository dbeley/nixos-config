{
  config,
  inputs,
  pkgs,
  ...
}:
let
  skills = builtins.listToAttrs (
    builtins.concatLists [
      # superpowers (from obra-superpowers)
      (map
        (name: {
          name = ".hermes/skills/${name}";
          value = {
            source = "${inputs.obra-superpowers}/skills/${name}";
            force = true;
          };
        })
        [
          "brainstorming"
          "dispatching-parallel-agents"
          "executing-plans"
          "finishing-a-development-branch"
          "receiving-code-review"
          "requesting-code-review"
          "subagent-driven-development"
          "systematic-debugging"
          "test-driven-development"
          "using-git-worktrees"
          "using-superpowers"
          "verification-before-completion"
          "writing-plans"
          "writing-skills"
        ]
      )
      # anthropic skills (from anthropic-skills)
      (map
        (name: {
          name = ".hermes/skills/${name}";
          value = {
            source = "${inputs.anthropic-skills}/skills/${name}";
            force = true;
          };
        })
        [
          "claude-api"
          "frontend-design"
          "mcp-builder"
          "skill-creator"
          "webapp-testing"
        ]
      )
      # last30days skill
      (map
        (name: {
          name = ".hermes/skills/${name}";
          value = {
            source = "${inputs.last30days-skill}/skills/${name}";
            force = true;
          };
        })
        [
          "last30days"
        ]
      )
      # ponytail skills
      (map
        (name: {
          name = ".hermes/skills/${name}";
          value = {
            source = "${inputs.ponytail}/skills/${name}";
            force = true;
          };
        })
        [
          "ponytail"
          "ponytail-review"
          "ponytail-audit"
          "ponytail-debt"
          "ponytail-help"
        ]
      )
      # rea skills
      (map
        (name: {
          name = ".hermes/skills/${name}";
          value = {
            source = "${inputs.rea}/.agents/skills/${name}";
            force = true;
          };
        })
        [
          "reverse-engineer-anything"
        ]
      )
    ]
  );
in
{
  home = {
    packages = [ pkgs.hermes-agent ];

    sessionVariables.HERMES_MANAGED_DIR = "${config.home.homeDirectory}/.hermes/managed";

    file = skills // {
      ".hermes/managed/config.yaml".text = ''
        mcp_servers:
          rea:
            command: "${pkgs.nodejs}/bin/npx"
            args: ["-y", "rea-agents@6.5.0", "mcp"]
            env:
              GHIDRA_INSTALL_DIR: "${pkgs.ghidra}/lib/ghidra"
              JAVA_HOME: "${pkgs.jdk21}/lib/openjdk"
            enabled: true
      '';
    };
  };
}
