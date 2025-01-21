{
  pkgs,
  user,
  inputs,
  stateVersion,
  ...
}:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../../apps/hyprland/hyprland.nix
    ../../apps/waybar/waybar.nix
    ../../apps/tofi/tofi.nix
    ../../apps/mako/mako.nix
    ../../apps/gammastep/gammastep.nix
    ../../apps/autoscreen/autoscreen.nix
    ../../apps/autoscreen-gaming/autoscreen-gaming.nix
    # ../../apps/gnome/gnome.nix
    # ../../apps/autoscreen-gnome/autoscreen-gnome.nix
    ../../apps/stylix/stylix.nix

    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/ghostty/ghostty.nix
    ../../apps/direnv/direnv.nix
    ../../apps/python/python.nix
    ../../apps/helix/helix.nix
    ../../apps/vscode/vscode.nix
    ../../apps/nnn/nnn.nix
    ../../apps/udiskie/udiskie.nix
    ../../apps/mime/mime.nix
    ../../apps/imv/imv.nix
    ../../apps/bat/bat.nix
    ../../apps/zoxide/zoxide.nix
    # ../../apps/zathura/zathura.nix

    ../../apps/firefox/firefox.nix
    ../../apps/qutebrowser/qutebrowser.nix
    ../../apps/ledger/ledger.nix
    ../../apps/mpd/mpd.nix
    ../../apps/mpdscrobble/mpdscrobble.nix
    ../../apps/mpv/mpv.nix
    ../../apps/steam/steam.nix
    ../../apps/nextcloud-client/nextcloud-client.nix
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
    audacity
    beets
    borgbackup
    borgmatic
    btop
    eza
    fd
    ffmpeg
    ffmpegthumbnailer
    gnome-system-monitor
    nautilus
    htop
    jamulus
    jq
    just
    keepassxc
    libreoffice-fresh
    musescore
    ncdu
    nitch
    papers
    pavucontrol
    ripgrep
    ripgrep-all
    shotcut
    supersonic
    ungoogled-chromium
    unzip
    wvkbd
    yt-dlp
  ];

  services.mpris-proxy.enable = true;
}
