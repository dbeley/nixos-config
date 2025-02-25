{
  pkgs,
  user,
  stateVersion,
  ...
}:
{
  imports = [
    ../../apps/stylix/stylix.nix

    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/direnv/direnv.nix
    ../../apps/python/python.nix
    # inputs.nixvim.homeManagerModules.nixvim
    # ../../apps/nixvim/nixvim.nix
    ../../apps/kakoune/kakoune.nix
    ../../apps/helix/helix.nix
    ../../apps/lazygit/lazygit.nix
    ../../apps/nnn/nnn.nix
    ../../apps/bat/bat.nix
    ../../apps/zoxide/zoxide.nix

    ../../apps/tealdeer/tealdeer.nix
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
    ffmpeg
    ffmpegthumbnailer
    htop
    jq
    just
    ncdu
    nitch
    ripgrep
    ripgrep-all
    unzip
  ];

  services.mpris-proxy.enable = false;
}
