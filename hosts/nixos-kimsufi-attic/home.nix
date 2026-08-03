{ pkgs, ... }:
{
  home.packages = with pkgs; [ attic-client ];
}
