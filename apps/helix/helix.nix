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
        cursorline = true;
        cursorcolumn = false;
        gutters = [ "diagnostics" "spacer" "line-numbers" "spacer" ];
        auto-completion = true;
        auto-format = true;
        auto-save = false;
        statusline = {
          left = [ "mode" "spinner" "file-name" ];
          center = [ "diagnostics" ];
          right = [ "position" "total-line-numbers" "file-type" "version-control" ];
        };
        scrolloff = 5;
        auto-pairs = true;
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
