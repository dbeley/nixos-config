{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    btop
    fish
    gh
    git
    helix
    just
    lazygit
    ripgrep-all
    tealdeer
    tmux
    unzip
    wireguard-tools
    zoxide
  ];
}
