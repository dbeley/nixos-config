{ pkgs, ... }:
{
  home.packages = with pkgs; [ emacs ];
  home.file.".config/doom/config.el".source = ./config.el;
  home.file.".config/doom/init.el".source = ./init.el;
  home.file.".config/doom/packages.el".source = ./packages.el;
}
