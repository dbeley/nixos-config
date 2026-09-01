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
      ip-as-logo = {
        input = "ip-as-logo-skill";
        subdir = ".";
      };
      ponytail = {
        input = "ponytail";
        subdir = "skills";
        idPrefix = "ponytail";
      };
      hyperdroid = {
        input = "hyperdroid-skill";
        subdir = "skills";
        idPrefix = "hyperdroid";
      };
      hallmark = {
        input = "hallmark";
        subdir = "skills";
        idPrefix = "hallmark";
      };
    };
    skills = {
      enableAll = [ "superpowers" ];
      enable = [
        "anthropic/skill-creator"
        "anthropic/mcp-builder"
        "anthropic/webapp-testing"
        "anthropic/claude-api"
        "superpowers/systematic-debugging"
        "superpowers/writing-plans"
        "superpowers/test-driven-development"
        "superpowers/brainstorming"
        "superpowers/verification-before-completion"
        "last30days/last30days"
        "ip-as-logo"
        "ponytail/ponytail"
        "ponytail/ponytail-review"
        "ponytail/ponytail-audit"
        "ponytail/ponytail-debt"
        "hyperdroid/android"
        "hyperdroid/android-fastboot"
        "hyperdroid/android-build"
        "hyperdroid/lineageos"
        "hallmark/hallmark"
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
      agents.enable = true;
    };
  };
}
