{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      mkhl.direnv
      github.copilot
      github.copilot-chat
      ms-python.python
      ms-python.vscode-pylance
      ms-azuretools.vscode-docker
      ms-python.debugpy
    ];
  };
}
