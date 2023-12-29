{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Iosevka Nerd Font";
      font_size = "12";
      background_opacity = "0.8";
      window_padding_width = "10 10";
      cursor_shape = "block";
      shell_integration = "no-cursor";
    };
    shellIntegration = {
      enableFishIntegration = true;
    };
  };
}
