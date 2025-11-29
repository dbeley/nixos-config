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
        auto-completion = true;
        auto-format = true;
        auto-save = false;
        scrolloff = 5;
        auto-pairs = true;
      };
    };
  };
  home.packages = with pkgs; [
    nixd
  ];
}
