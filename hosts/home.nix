{ config, pkgs, user, inputs, hyprland, ... }:

{
  imports = [
    ./apps/gnome/gnome.nix
    hyprland.homeManagerModules.default
    ./apps/hyprland/hyprland.nix
    ./apps/waybar/waybar.nix
    ./apps/wofi/wofi.nix

    ./apps/git/git.nix
    ./apps/fish/fish.nix
    ./apps/tmux/tmux.nix
    ./apps/alacritty/alacritty.nix
    ./apps/nvim/nvim.nix
    ./apps/wpgtk/wpgtk.nix

    ./apps/firefox/firefox.nix
    # ./apps/mpd/mpd.nix
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
    nnn
    gnome.gnome-system-monitor
    ];
}
