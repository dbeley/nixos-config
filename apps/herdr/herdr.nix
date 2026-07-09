{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.herdr.packages.${pkgs.system}.default ];
}
