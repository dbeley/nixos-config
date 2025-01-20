{ pkgs, lib, ... }:
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
      vue.volar
      charliermarsh.ruff
    ];
    userSettings = {
      "files.autoSave" = "off";
      "editor.fontSize" = lib.mkForce 16;
      "editor.wordWrap" = "on";
      "window.zoomLevel" = 2;
      "[python]" = {
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
          "source.organizeImports" = "explicit";
        };
        "editor.defaultFormatter" = "charliermarsh.ruff";
      };
      "ruff.lineLength" = 120;
    };
  };
}
