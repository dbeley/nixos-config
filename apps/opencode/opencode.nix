{ inputs, pkgs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.system};
  # `npx` is a JS script with a `#!/usr/bin/env node` shebang, so node must be
  # on PATH when the REA MCP server starts.
  rea-mcp = pkgs.writeShellScript "rea-mcp" ''
    export PATH=${pkgs.nodejs}/bin:$PATH
    exec ${pkgs.nodejs}/bin/npx -y rea-agents@6.5.0 mcp "$@"
  '';
in
{
  imports = [ inputs.agent-skills.homeManagerModules.default ];
  home.packages = [
    llm.opencode2
  ];
  xdg.configFile = {
    "opencode/opencode.json" = {
      force = true;
      text = builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        share = "disabled";
        theme = "system";
        model = "opencode-go/deepseek-v4.1-flash";
        mcp = {
          rea = {
            type = "local";
            command = [ "${rea-mcp}" ];
            environment = {
              GHIDRA_INSTALL_DIR = "${pkgs.ghidra}/lib/ghidra";
              JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
            };
            enabled = true;
          };
        };
        command = {
          last30days = {
            description = "Research any topic across Reddit, X, YouTube, TikTok, HN, Polymarket, GitHub, and the web";
            template = "Run the last30days skill to research this topic across all available sources: {{input}}";
          };
        };
      };
    };
    "opencode/cli.json" = {
      force = true;
      text = builtins.toJSON {
        "$schema" = "https://opencode.ai/v2/cli.json";
        theme.name = "system";
        diffs.wrap = "word";
        session = {
          sidebar = "auto";
          scrollbar = false;
          thinking = "hide";
        };
        animations = true;
        attention = {
          enabled = true;
          notifications = true;
          sound = false;
        };
      };
    };
  };
}
