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
