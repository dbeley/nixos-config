{ pkgs, ... }:
{
  home.packages = with pkgs; [ moonlight-qt ];
}
