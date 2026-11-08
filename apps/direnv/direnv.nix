{ inputs, ... }:
{
  imports = [ inputs.direnv-instant.homeModules.direnv-instant ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.direnv-instant = {
    enable = true;
    settings.mux_delay = 2;
  };
}
