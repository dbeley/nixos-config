{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.impulse.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
