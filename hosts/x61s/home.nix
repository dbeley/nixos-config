{
  pkgs,
  user,
  ...
}: {
  imports = [
    ../../apps/sway/sway.nix
    ../../apps/waybar/waybar.nix
    ../../apps/tofi/tofi.nix

    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    # ../../apps/alacritty/alacritty.nix
    ../../apps/kitty/kitty.nix
    # ../../apps/nvim/nvim.nix
    ../../apps/nixvim/nixvim.nix
    ../../apps/emacs/emacs.nix
    ../../apps/kakoune/kakoune.nix
    ../../apps/helix/helix.nix
    # ../../apps/lf/lf.nix
    ../../apps/nnn/nnn.nix
    ../../apps/wal/wal.nix
    ../../apps/wpgtk/wpgtk.nix
    ../../apps/udiskie/udiskie.nix
    ../../apps/mime/mime.nix
    ../../apps/swayimg/swayimg.nix
    ../../apps/bat/bat.nix

    ../../apps/firefox/firefox.nix
    ../../apps/qutebrowser/qutebrowser.nix
    ../../apps/gammastep/gammastep.nix
    ../../apps/ledger/ledger.nix
    ../../apps/mpd/mpd.nix
    ../../apps/mpv/mpv.nix
    ../../apps/zathura/zathura.nix
    ../../apps/autoscreen/autoscreen.nix
    # ../../apps/mpdscrobble/mpdscrobble.nix
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
    beets
    borgbackup
    borgmatic
    btop
    eza
    fd
    ffmpeg
    ffmpegthumbnailer
    fio
    gh
    gnome.gnome-keyring
    gnome.gnome-system-monitor
    gthumb
    htop
    hugo
    jq
    keepassxc
    libreoffice-fresh
    ncdu
    nextcloud-client
    nitch
    pavucontrol
    ripgrep
    ripgrep-all
    rsync
    stow
    # ungoogled-chromium
    unzip
    xfce.thunar
    xfce.tumbler
    yt-dlp

    discord
    element-desktop

    # dev dependencies
    clang
    gnumake
    cmake
    libtool

    nil
    nvd

    python3
    nodePackages.pyright
  ];

  services.mpris-proxy.enable = true;
}
