{
  nix-doom-emacs,
  pkgs,
  ...
}: {
  imports = [nix-doom-emacs.hmModule];
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };
  home.packages = with pkgs; [pandoc];
}
