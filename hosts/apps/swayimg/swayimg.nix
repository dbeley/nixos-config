{ pkgs, ... }:

{
  home.packages = with pkgs; [
    swayimg
  ];
  home.file.".config/swayimg/config".source = ./swayimgrc;
}
