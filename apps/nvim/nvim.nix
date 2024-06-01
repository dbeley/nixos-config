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
      vim-startify
      # gruvbox
      vim-airline
      vim-airline-themes
      tmuxline-vim
      fzf-vim
      goyo-vim
      deoplete-nvim
      deoplete-jedi
      ale
      vim-devicons
      vim-nix
    ];
    extraConfig = lib.fileContents ./init.vim;
  };
}
