{ pkgs, ... }:
{
  home.packages = with pkgs; [ ungoogled-chromium ];
}
