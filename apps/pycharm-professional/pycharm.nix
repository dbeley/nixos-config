{ pkgs, ... }:
{
  home.packages = with pkgs; [ jetbrains.pycharm-professional ];
  home.file.".ideavimrc".source = ./ideavimrc;
}
