{ pkgs, lib, ... }:
let
  skillsConfig = import ./skills.nix { inherit pkgs lib; };
  mcpConfig = import ./mcp.nix { inherit pkgs lib; };

  # Helper function to create xdg.configFile entries for each skill
  mkSkillFile =
    skill:
    let
      fetched = pkgs.fetchFromGitHub {
        owner = skill.owner;
        repo = skill.repo;
        rev = skill.rev;
        sha256 = skill.sha256;
      };
      source = if skill ? subPath then "${fetched}/${skill.subPath}" else fetched;
    in
    {
      name = "opencode/skills/${skill.skillName or skill.repo}";
      value = {
        source = source;
      };
    };

  # Create all skill symlinks
  skillFiles = builtins.listToAttrs (map mkSkillFile skillsConfig.skills);
in
{
  home.packages = with pkgs; [ opencode ] ++ mcpConfig.home.packages;

  # Create skills directory and symlink all fetched skills
  xdg.configFile =
    skillFiles
    // (mcpConfig.xdg.configFile or { })
    // {
      # Ensure skills directory exists
      "opencode/skills/.gitkeep".text = "";
    };

  # Include MCP file configurations
  home.file = (mcpConfig.home.file or { });
}
