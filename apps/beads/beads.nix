{ inputs, pkgs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.system};
in
{
  home.packages = [ llm.beads ];
}
