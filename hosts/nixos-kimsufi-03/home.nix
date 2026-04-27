{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lazydocker
  ];
}
