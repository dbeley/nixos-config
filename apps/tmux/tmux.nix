{ lib, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    baseIndex = 1;
    keyMode = "vi";
    historyLimit = 999999;
    escapeTime = 0;
    clock24 = true;
    extraConfig = lib.fileContents ./tmux.conf;
  };
}
