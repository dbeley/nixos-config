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
      last30days = {
        input = "last30days-skill";
        subdir = "skills";
        idPrefix = "last30days";
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
        "superpowers/systematic-debugging" # debugging any issues
        "superpowers/writing-plans" # planning features before implementation
        "superpowers/test-driven-development" # TDD approach
        "superpowers/brainstorming" # creative problem solving
        "superpowers/verification-before-completion" # verifying work before claiming completion
        "last30days/last30days" # research topics across Reddit, X, YouTube, HN, Polymarket, and the web
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
