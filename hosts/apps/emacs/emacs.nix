 { nix-doom-emacs, ... }:

 {
   imports = [ nix-doom-emacs.hmModule ];
   programs.doom-emacs = {
     enable = true;
     doomPrivateDir = ./doom.d;
   };
 }
