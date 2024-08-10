{
  programs.nixvim = {
    enable = true;

    globals.mapleader = ";"; # Sets the leader key to comma

    opts = {
      number = true; # Show line numbers
      relativenumber = false; # Show relative line numbers
      incsearch = true;
      expandtab = true;
      shiftwidth = 2; # Tab width should be 2
      tabstop = 2;
      termguicolors = true;
      ignorecase = true;
      smartcase = true;
    };

    plugins = {
      airline = {
        enable = true;
        settings = {
          powerline_fonts = true;
        };
      };
      alpha = {
        enable = true;
        theme = "dashboard";
      };
      bufferline.enable = true;
      comment.enable = true;
      diffview.enable = true;
      fugitive.enable = true;
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };
      leap.enable = true;
      lsp-format.enable = true;
      markdown-preview.enable = true;
      # mini.enable = true;
      navbuddy.enable = true;
      # neorg.enable = true;
      neo-tree.enable = true;
      notify.enable = true;
      sniprun.enable = true;
      surround.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
      treesitter-context.enable = true;
      trouble.enable = true;
      which-key.enable = true;

      lsp = {
        enable = true;
        servers = {
          bashls = {
            enable = true;
            autostart = true;
          };
          html = {
            enable = true;
            autostart = true;
          };
          nil-ls = {
            enable = true;
            autostart = true;
          };
          pyright = {
            enable = true;
            autostart = true;
          };
        };
      };

      cmp.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-rg.enable = true;
    };

    keymaps = [
      {
        key = "<C-s>";
        action = ":w<CR>";
      }
      {
        key = "<esc>";
        action = ":noh<CR>";
        options = {
          silent = true;
        };
      }
      {
        key = "<leader>k";
        action = "<cmd>bdelete<cr>";
      }
      {
        key = "<leader>f";
        action = "<cmd>Telescope find_files<cr>";
      }
      {
        key = "<leader>g";
        action = "<cmd>Telescope live_grep<cr>";
      }
      {
        key = "<leader>b";
        action = "<cmd>Telescope buffers<cr>";
      }
      {
        key = "<leader>t";
        action = "<cmd>Telescope help_tags<cr>";
      }
      {
        key = "<leader>nn";
        action = "<cmd>Neotree<cr>";
      }
      {
        key = "<leader>nb";
        action = "<cmd>Neotree buffers<cr>";
      }
      {
        key = "<leader>ng";
        action = "<cmd>Neotree float git_status<cr>";
      }
      {
        key = "<leader>nc";
        action = "<cmd>Neotree close<cr>";
      }
      {
        key = "<leader>sr";
        action = "<cmd>SnipRun<cr>";
      }
      {
        key = "<leader>ss";
        action = "<cmd>'<,'>SnipRun<cr>";
      }
      {
        key = "<leader>sd";
        action = "<cmd>SnipReset<cr>";
      }
      {
        key = "<leader>sc";
        action = "<cmd>SnipClose<cr>";
      }
    ];
  };
}
