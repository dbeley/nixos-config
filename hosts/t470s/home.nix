{
  config,
  pkgs,
  user,
  inputs,
  hyprland,
  nix-doom-emacs,
  ...
}: {
  imports = [
    hyprland.homeManagerModules.default
    ../apps/hyprland/hyprland.nix
    ../apps/waybar/waybar.nix
    ../apps/tofi/tofi.nix

    ../apps/git/git.nix
    ../apps/fish/fish.nix
    ../apps/tmux/tmux.nix
    ../apps/alacritty/alacritty.nix
    ../apps/nvim/nvim.nix
    ../apps/emacs/emacs.nix
    ../apps/kakoune/kakoune.nix
    ../apps/wal/wal.nix
    ../apps/wpgtk/wpgtk.nix
    ../apps/udiskie/udiskie.nix
    ../apps/mime/mime.nix
    ../apps/swayimg/swayimg.nix
    ../apps/bat/bat.nix

    ../apps/firefox/firefox.nix
    # ../apps/qutebrowser/qutebrowser.nix
    ../apps/gammastep/gammastep.nix
    ../apps/ledger/ledger.nix
    ../apps/mpd/mpd.nix
    ../apps/mpv/mpv.nix
    ../apps/obs/obs.nix
    ../apps/zathura/zathura.nix
    # ../apps/autoscreen/autoscreen.nix
    # ../apps/mpdscrobble/mpdscrobble.nix
    ../apps/steam/steam.nix
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
    gnome.gnome-keyring
    libreoffice-fresh
    ungoogled-chromium
    p7zip
    rsync
    ncdu
    htop
    stow
    ripgrep
    fd
    exa
    nitch
    nnn
    gnome.gnome-system-monitor
    gh
    xfce.thunar
    xfce.tumbler
    ffmpegthumbnailer
    borgbackup
    borgmatic
    yt-dlp
  ];

  services.mpris-proxy.enable = true;
}
