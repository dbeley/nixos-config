{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.workmux.packages.${pkgs.system}.default ];

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
