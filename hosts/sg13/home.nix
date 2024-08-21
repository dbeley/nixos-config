{
  pkgs,
  user,
  inputs,
  stateVersion,
  ...
}:
{
  imports = [
    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    inputs.nixvim.homeManagerModules.nixvim
    ../../apps/nixvim/nixvim.nix
    ../../apps/helix/helix.nix
    ../../apps/udiskie/udiskie.nix
    ../../apps/bat/bat.nix
    ../../apps/stylix/stylix.nix

    ../../apps/firefox/firefox.nix
    ../../apps/steam/steam.nix
    ../../apps/direnv/direnv.nix
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
  home.stateVersion = "${stateVersion}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    btop
    eza
    fd
    gnome-system-monitor
    just
    keepassxc
    libreoffice-fresh
    ncdu
    # nextcloud-client
    ripgrep
    ripgrep-all
    rsync
    supersonic
    ungoogled-chromium
    yt-dlp
  ];

  services.mpris-proxy.enable = true;
}
