{ pkgs, inputs, ... }:
{
  environment.systemPackages = [ inputs.cursor.packages.${pkgs.system}.default ];
}
