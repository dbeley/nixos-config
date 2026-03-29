{ inputs, pkgs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.system};
in
{
  home.packages = [ llm.workmux ];

  xdg.configFile."workmux/config.yaml".text = ''
    merge_strategy: rebase
    agent: opencode
    panes:
      - command: <agent>
        focus: true
      - split: horizontal
  '';

  programs.fish.interactiveShellInit = ''
    workmux completions fish | source
  '';
}
