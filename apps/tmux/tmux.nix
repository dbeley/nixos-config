{ lib, ... }:
{
  xdg.configFile."tmux/tmuxline.conf".source = ./tmuxline.conf;
  programs.tmux = {
    enable = true;
    extraConfig = lib.fileContents ./tmux.conf;
  };
}
