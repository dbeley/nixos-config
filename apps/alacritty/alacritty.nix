{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.8;
        padding = {
          x = 15;
          y = 15;
        };
      };
      font = {
        size = 12;
      };
      colors = {
        transparent_background_colors = true;
      };
    };
  };
}
