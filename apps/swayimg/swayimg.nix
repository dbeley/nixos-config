{ pkgs, ... }:
{
  home.packages = with pkgs; [ swayimg ];
  xdg.configFile."swayimg/config".source = ./swayimgrc;
}
