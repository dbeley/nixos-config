{
  pkgs,
  inputs,
  user,
  lib,
  ...
}:
{
  imports = [
    ../home-manager-common-config.nix
    # inputs.nix-flatpak.homeManagerModules.nix-flatpak
    # ../../apps/flatpak/flatpak.nix
    # inputs.hyprland.homeManagerModules.default
    # ../../apps/hyprland/hyprland.nix
    # ../../apps/gnome/gnome.nix
    inputs.niri.homeModules.niri
    inputs.niri.homeModules.stylix
    ../../apps/niri/niri.nix
    ../../apps/stylix/stylix.nix
    ../../apps/hyprlock/hyprlock.nix
    ../../apps/hypridle/hypridle.nix
    ../../apps/waybar/waybar.nix
    ../../apps/tofi/tofi.nix
    ../../apps/mako/mako.nix
    ../../apps/gammastep/gammastep.nix

    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/ghostty/ghostty.nix
    ../../apps/direnv/direnv.nix
    ../../apps/python/python.nix
    # inputs.nixvim.homeManagerModules.nixvim
    # ../../apps/nixvim/nixvim.nix
    # ../../apps/emacs/emacs.nix
    # ../../apps/kakoune/kakoune.nix
    ../../apps/helix/helix.nix
    # ../../apps/vscode/vscode.nix
    ../../apps/lazygit/lazygit.nix
    ../../apps/nnn/nnn.nix
    ../../apps/udiskie/udiskie.nix
    ../../apps/mime/mime.nix
    ../../apps/imv/imv.nix
    ../../apps/bat/bat.nix
    ../../apps/zoxide/zoxide.nix
    ../../apps/zathura/zathura.nix

    ../../apps/firefox/firefox.nix
    ../../apps/zen-browser/zen-browser.nix
    # ../../apps/ungoogled-chromium/ungoogled-chromium.nix
    ../../apps/pycharm-professional/pycharm.nix
    ../../apps/tealdeer/tealdeer.nix
  ];

  home.packages = with pkgs; [
    gh
    nautilus
    supersonic
    google-chrome

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
    insomnia
    nodejs
    postgresql
  ];

  programs.firefox.profiles.${user}.extensions.packages = lib.mkMerge [
    (with pkgs.nur.repos.rycee.firefox-addons; [
      okta-browser-plugin
      onepassword-password-manager
    ])
  ];

  xdg.mimeApps = {
    defaultApplications = {
      "application/xhtml+xml" = lib.mkForce [ "google-chrome.desktop" ];
      "application/xhtml_xml" = lib.mkForce [ "google-chrome.desktop" ];
      "text/html" = lib.mkForce [ "google-chrome.desktop" ];
      "x-scheme-handler/http" = lib.mkForce [ "google-chrome.desktop" ];
      "x-scheme-handler/https" = lib.mkForce [ "google-chrome.desktop" ];
    };
  };
}
