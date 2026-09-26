{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    btop
    fish
    gh
    git
    kakoune
    just
    lazygit
    p7zip
    ripgrep-all
    tealdeer
    tmux
    wireguard-tools
    zoxide
  ];
}
