{
  pkgs,
  user,
  lib,
  inputs,
  stateVersion,
  ...
}:
{
  imports = [
    # inputs.hyprland.homeManagerModules.default
    # ../../apps/hyprland/hyprland.nix
    # ../../apps/waybar/waybar.nix
    # ../../apps/tofi/tofi.nix
    # ../../apps/mako/mako.nix
    # ../../apps/gammastep/gammastep.nix
    ../../apps/gnome/gnome.nix
    ../../apps/stylix/stylix.nix

    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/kitty/kitty.nix
    ../../apps/direnv/direnv.nix
    # inputs.nixvim.homeManagerModules.nixvim
    # ../../apps/nixvim/nixvim.nix
    ../../apps/emacs/emacs.nix
    ../../apps/kakoune/kakoune.nix
    ../../apps/helix/helix.nix
    ../../apps/vscode/vscode.nix
    ../../apps/lazygit/lazygit.nix
    ../../apps/nnn/nnn.nix
    ../../apps/udiskie/udiskie.nix
    ../../apps/mime/mime.nix
    ../../apps/imv/imv.nix
    ../../apps/bat/bat.nix
    ../../apps/zoxide/zoxide.nix
    ../../apps/zathura/zathura.nix

    ../../apps/firefox/firefox.nix
    ../../apps/pycharm-professional/pycharm.nix
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
    gh
    gnome-system-monitor
    htop
    insomnia
    jq
    just
    # libreoffice-fresh
    nautilus
    ncdu
    nitch
    pavucontrol
    ripgrep
    ripgrep-all
    supersonic
    ungoogled-chromium
    unzip

    python3
    pyright

    slack
    awscli2
    zoom-us
    teleport
    kubectl
    cloudflared
    google-cloud-sdk
    vault
    gnumake
    gcc
    file
    pango
    mecab
    libffi
  ];

  services.mpris-proxy.enable = true;

  programs.firefox.profiles.${user}.extensions = lib.mkMerge [
    (with pkgs.nur.repos.rycee.firefox-addons; [
      okta-browser-plugin
      onepassword-password-manager
    ])
  ];
}
