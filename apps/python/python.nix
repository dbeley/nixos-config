{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python3
    pyright
    ruff
    poetry
    uv
  ];
}
