{
  pkgs,
  user,
  inputs,
  stateVersion,
  ...
}:
{
  imports = [
    ../../apps/stylix/stylix.nix
    ../../apps/gnome/gnome.nix

    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/helix/helix.nix
    ../../apps/nnn/nnn.nix
    ../../apps/udiskie/udiskie.nix
    ../../apps/mime/mime.nix
    ../../apps/bat/bat.nix
    ../../apps/zoxide/zoxide.nix

    ../../apps/firefox/firefox.nix
    ../../apps/qutebrowser/qutebrowser.nix
    ../../apps/ledger/ledger.nix
    ../../apps/mpd/mpd.nix
    ../../apps/mpdscrobble/mpdscrobble.nix
    ../../apps/mpv/mpv.nix
    ../../apps/steam/steam.nix
    ../../apps/nextcloud-client/nextcloud-client.nix
    ../../apps/tealdeer/tealdeer.nix
    ../../apps/autoscreen-gnome/autoscreen-gnome.nix
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
    audacity
    beets
    btop
    eza
    fd
    ffmpeg
    ffmpegthumbnailer
    gnome-system-monitor
    htop
    jq
    just
    keepassxc
    libreoffice-fresh
    ncdu
    nitch
    ripgrep
    ripgrep-all
    supersonic
    ungoogled-chromium
    unzip
    yt-dlp

    nvd
  ];

  services.mpris-proxy.enable = true;
}
