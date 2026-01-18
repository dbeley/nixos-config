{
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      font_size = "12";
      window_padding_width = "10 10";
      cursor_shape = "block";
      shell_integration = "no-cursor";
      allow_remote_control = true;
      hide_window_decorations = "yes";
    };
    shellIntegration = {
      enableFishIntegration = true;
    };
    keybindings = {
      "ctrl+shift+j" = "previous_tab";
      "ctrl+shift+k" = "next_tab";
    };
  };
}
