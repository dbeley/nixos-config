 { lib, ... }:

 {
   programs.neovim = {
     enable = true;
     extraConfig = lib.fileContents ./init.vim;
   };
 }
