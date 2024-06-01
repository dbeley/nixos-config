{ pkgs, ... }:
{
  home.packages = with pkgs; [ tofi ];
  home.file.".config/tofi/config".source = ./config;
}
