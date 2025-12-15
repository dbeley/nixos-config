{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.impulse.packages.${pkgs.system}.default
  ];
}
