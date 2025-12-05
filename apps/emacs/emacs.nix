{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ emacs ];
    file = {
      ".config/doom/config.el".source = ./config.el;
      ".config/doom/init.el".source = ./init.el;
      ".config/doom/packages.el".source = ./packages.el;
    };
  };
}
