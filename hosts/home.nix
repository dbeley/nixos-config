{ config, pkgs, user, inputs, ... }:

{
  imports = [
    ./apps/fish.nix
    ./apps/firefox.nix
    ./apps/nvim.nix
    #./apps/hyprland.nix
    #./apps/waybar.nix
    ./apps/tmux.nix
    ./apps/alacritty.nix
    ./apps/gnome.nix
    ./apps/git.nix
    ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = user;
  home.homeDirectory = "/home/${user}";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    keepassxc
    nextcloud-client
    libreoffice-fresh
    tmux
    p7zip
    rsync
    ncdu
    htop
    stow
    ripgrep
    exa
    bat
    neofetch
    fzf
    gnome.gnome-system-monitor
    gnome.gnome-tweaks
    overpass
    ];
}
