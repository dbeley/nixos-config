{ pkgs, ... }:
{
  home.packages = with pkgs; [ jetbrains.pycharm-community ];
  home.file.".ideavimrc".source = ./ideavimrc;
}
