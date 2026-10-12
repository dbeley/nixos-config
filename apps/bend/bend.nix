{ inputs, pkgs, ... }:
{
  # Bend 2 (from the bendlang/bend flake input), not nixpkgs' incompatible
  # Bend 1. Opt in per host with the `bend` profile in hosts/default.nix.
  home.packages = [ inputs.bend.packages.${pkgs.system}.default ];
}
