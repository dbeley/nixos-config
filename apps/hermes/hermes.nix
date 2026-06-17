{ inputs, pkgs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.system};

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
    ]
  );
in
{
  home.packages = [ llm.hermes-agent ];
  home.file = skills;
}
