{ pkgs, user, inputs, stateVersion, ... }: {
  imports = [
    # Hyprland
    # inputs.hyprland.homeManagerModules.default
    # ../../apps/hyprland/hyprland.nix
    # ../../apps/waybar/waybar.nix
    # ../../apps/tofi/tofi.nix

    # Gnome
    ../../apps/gnome/gnome.nix

    # Apps
    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/kitty/kitty.nix
    ../../apps/direnv/direnv.nix
    inputs.nixvim.homeManagerModules.nixvim
    ../../apps/nixvim/nixvim.nix
    # ../../apps/emacs/emacs.nix
    # ../../apps/kakoune/kakoune.nix
    # ../../apps/helix/helix.nix
    # ../../apps/lazygit/lazygit.nix
    # ../../apps/nnn/nnn.nix
    # ../../apps/wal/wal.nix
    # ../../apps/wpgtk/wpgtk.nix
    # ../../apps/udiskie/udiskie.nix
    # ../../apps/mime/mime.nix
    # ../../apps/swayimg/swayimg.nix
    # ../../apps/bat/bat.nix
    # ../../apps/zoxide/zoxide.nix
    # ../../apps/firefox/firefox.nix
    # ../../apps/qutebrowser/qutebrowser.nix
    # ../../apps/gammastep/gammastep.nix
    # ../../apps/mpd/mpd.nix
    # ../../apps/mpv/mpv.nix
    # ../../apps/obs/obs.nix
    # ../../apps/zathura/zathura.nix
    # ../../apps/steam/steam.nix
    # ../../apps/pycharm/pycharm.nix
    # ../../apps/tealdeer/tealdeer.nix
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
    fio
    gh
    gnome.gnome-system-monitor
    gthumb
    htop
    jq
    just
    keepassxc
    libreoffice-fresh
    ncdu
    nitch
    pavucontrol
    ripgrep
    ripgrep-all
    rsync
    ungoogled-chromium
    unzip
    xfce.thunar
    xfce.tumbler
    yt-dlp

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
