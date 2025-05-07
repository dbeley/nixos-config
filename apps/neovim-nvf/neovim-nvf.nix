{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;
        lsp.enable = true;
        git.enable = true;

        globals = {
          mapleader = ";";
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          nix.enable = true;
          python.enable = true;
          bash.enable = true;
          sql.enable = true;
        };

        autocomplete.nvim-cmp.enable = true;
        dashboard.dashboard-nvim.enable = true;
        filetree.neo-tree.enable = true;
        statusline.lualine.enable = true;
        telescope.enable = true;
        treesitter.enable = true;
        utility.motion.leap.enable = true;
      };
    };
  };
}
