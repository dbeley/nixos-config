{ pkgs, ... }:
{
  home.packages = with pkgs; [ llmfit ];
}
