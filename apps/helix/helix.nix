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
  };
  home.packages = with pkgs; [
    # nil
    nixd
  ];
}
