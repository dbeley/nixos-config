{ pkgs, inputs, ... }:
{
  home.packages = [ inputs.undertone.packages.${pkgs.stdenv.hostPlatform.system}.undertone ];
}
