{
  programs.nixvim = {
    enable = true;

    colorschemes = {
      nord = {
        enable = true;
	disable_background = true;
      };
    };

    plugins = {
      airline = {
        enable = true;
	powerline = true;
	theme = "minimalist";
      };
      telescope.enable = true;
      alpha.enable = true;
      bufferline.enable = true;

      nvim-cmp.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-rg.enable = true;

      comment-nvim.enable = true;
      diffview.enable = true;
      fugitive.enable = true;
      gitsigns.enable = true;
      hardtime = {
        enable = true;
	enabled = true;
      };
      leap.enable = true;
      lsp = {
        enable = true;
	servers = {
	  bashls.enable = true;
          html.enable = true;
	  nil_ls.enable = true;
	  pylsp.enable = true;
	};
      };
      lsp-format.enable = true;
      markdown-preview.enable = true;
      mini.enable = true;
      navbuddy.enable = true;
      neo-tree.enable = true;
      notify.enable = true;
      sniprun.enable = true;
      surround.enable = true;

      trouble.enable = true;
      which-key.enable = true;
    };

    globals.mapleader = ";"; # Sets the leader key to comma

    options = {
      number = true;         # Show line numbers
      relativenumber = false; # Show relative line numbers
      incsearch = true;
      shiftwidth = 2;        # Tab width should be 2
    };
  };
}
