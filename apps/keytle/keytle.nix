{ pkgs, inputs, ... }:
{
  home.packages = [ inputs.keytle.packages.${pkgs.stdenv.hostPlatform.system}.keytle ];
}
