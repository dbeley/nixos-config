{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    thunar
    tumbler
  ];
}
