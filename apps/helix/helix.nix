{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
  };
  home.packages = with pkgs; [
    nil
  ];
}
