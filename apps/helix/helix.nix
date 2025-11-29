{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    languages.language = [
      {
        name = "nix";
        auto-format = true;
      }
      {
        name = "python";
        auto-format = true;
      }
      {
        name = "json";
        auto-format = false;
      }
    ];
    settings = {
      editor = {
        clipboard-provider = "osc52";
        cursorline = true;
        cursorcolumn = false;
        gutters = [ "diagnostics" "spacer" "line-numbers" "spacer" ];
        auto-completion = true;
        auto-format = true;
        auto-save = false;
        format-on-save = true;
        statusline = {
          left = [ "mode" "spinner" "file_name" ];
          center = [ "diagnostics" ];
          right = [ "position" "total_line_count" "file_type" ];
        };
        scrolloff = 5;
        auto-pairs = true;
        matching-brackets = "always";
        whitespace = {
          render = "all";
          characters = {
            space = "·";
            nbsp = "⍽";
            tab = "⇥";
          };
        };
      };
    };
  };
  home.packages = with pkgs; [
    # nil
    nixd
  ];
}
