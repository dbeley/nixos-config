{ lib, ... }:
{
  programs.tofi = {
    enable = true;
    settings = {
      font-size = lib.mkForce "25";
      font-features = "";
      font-variations = "";
      hint-font = true;
      prompt-background-padding = 0;
      prompt-background-corner-radius = 0;
      placeholder-background-padding = 0;
      placeholder-background-corner-radius = 0;
      input-background-padding = 0;
      input-background-corner-radius = 0;
      default-result-background-padding = 0;
      default-result-background-corner-radius = 0;
      selection-background-padding = 0;
      selection-background-corner-radius = 0;
      prompt-text = "run: ";
      prompt-padding = 0;
      placeholder-text = "";
      num-results = 10;
      result-spacing = 25;
      horizontal = false;
      min-input-width = 0;
      width = "100%";
      height = "100%";
      outline-width = 0;
      border-width = 0;
      corner-radius = 0;
      padding-top = "15%";
      padding-left = "35%";
      padding-right = "35%";
      clip-to-padding = true;
      scale = true;
      output = "";
      anchor = "center";
      exclusive-zone = -1;
      margin-top = 0;
      margin-bottom = 0;
      margin-left = 0;
      margin-right = 0;
      hide-cursor = false;
      history = true;
      fuzzy-match = false;
      require-match = true;
      hide-input = false;
      hidden-character = "*";
      drun-launch = false;
      late-keyboard-init = false;
      multi-instance = false;
      ascii-input = false;
    };
  };
}
