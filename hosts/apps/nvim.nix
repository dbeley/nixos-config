 { lib, pkgs, ... }:

 {
   programs.neovim = {
     enable = true;
     viAlias = true;
     vimAlias = true;
     vimdiffAlias = true;
     withPython3 = true;

     plugins = with pkgs.vimPlugins; [
       vim-sensible
       vim-surround
       vim-fugitive
       vim-commentary
     ];
     extraConfig = lib.fileContents ./init.vim;
   };
 }
