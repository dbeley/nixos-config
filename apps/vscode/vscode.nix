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
    userSettings = {
      "files.autoSave" = "off";
      "editor.fontSize" = 16;
      "editor.wordWrap" = "on";
    };
  };
}
