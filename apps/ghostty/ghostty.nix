{ pkgs, ... }:
{
  home.packages = [ pkgs.ghostty.terminfo ];

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      window-decoration = false;
      window-padding-y = 10;
      window-padding-x = 10;
      window-inherit-working-directory = false;
    };
  };
}
