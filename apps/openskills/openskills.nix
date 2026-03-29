_: {
  programs.agent-skills = {
    enable = true;
    sources = {
      anthropic = {
        input = "anthropic-skills";
        subdir = "skills";
        idPrefix = "anthropic";
      };
      superpowers = {
        input = "obra-superpowers";
        subdir = "skills";
        idPrefix = "superpowers";
      };
    };
    skills = {
      enableAll = [ "superpowers" ];
      enable = [
        "anthropic/skill-creator" # creating/improving skills themselves
        "anthropic/mcp-builder" # building MCP servers
        "anthropic/frontend-design" # frontend work
        "anthropic/webapp-testing" # playwright testing
        "anthropic/claude-api" # building with Claude API
      ];
    };
    targets = {
      opencode = {
        enable = true;
        dest = "$HOME/.config/opencode/skills";
        structure = "symlink-tree";
      };
      claude.enable = true;
      codex.enable = true;
      cursor.enable = true;
      # agents target uses ~/.agents/skills (universal path)
      agents.enable = true;
    };
  };
}
