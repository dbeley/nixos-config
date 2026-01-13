{ pkgs, ... }:
{
  home.packages = with pkgs; [ jetbrains.pycharm ];
  home.file.".ideavimrc".source = ./ideavimrc;
}
