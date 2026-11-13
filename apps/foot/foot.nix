{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.foot.terminfo ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        pad = "8x8";
      };
      scrollback = {
        lines = 10000;
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
