{ inputs, pkgs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.system};
  opencode-wrapped = pkgs.symlinkJoin {
    name = "opencode-wrapped";
    paths = [ llm.opencode2 ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/opencode2 --set OPENCODE_ENABLE_EXA 1
    '';
  };
in
{
  imports = [ inputs.agent-skills.homeManagerModules.default ];
  home.packages = [
    opencode-wrapped
  ];
  xdg.configFile = {
    "opencode/opencode.json" = {
      force = true;
      text = builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        share = "disabled";
        theme = "system";
        model = "opencode-go/deepseek-v4-flash";
        plugins = [
          # ponytail is disabled: it targets the V1 plugin API, and V1 plugins
          # do not load in OpenCode V2. Re-enable once upstream ships a
          # V2-compatible plugin.
          # "${inputs.ponytail}/.opencode/plugins/ponytail.mjs"
        ];
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
