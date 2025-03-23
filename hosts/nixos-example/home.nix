{
  pkgs,
  user,
  inputs,
  ...
}:
{
  imports = [
    ../home-manager-common-config.nix
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
    ../../apps/ghostty/ghostty.nix
    ../../apps/direnv/direnv.nix
    inputs.nixvim.homeManagerModules.nixvim
    ../../apps/nixvim/nixvim.nix
    # ../../apps/emacs/emacs.nix
    # ../../apps/kakoune/kakoune.nix
    # ../../apps/helix/helix.nix
    # ../../apps/lazygit/lazygit.nix
    # ../../apps/nnn/nnn.nix
    # ../../apps/udiskie/udiskie.nix
    # ../../apps/mime/mime.nix
    # ../../apps/swayimg/swayimg.nix
    # ../../apps/bat/bat.nix
    # ../../apps/zoxide/zoxide.nix
    # ../../apps/firefox/firefox.nix
    # ../../apps/ungoogled-chromium/ungoogled-chromium.nix
    # ../../apps/qutebrowser/qutebrowser.nix
    # ../../apps/gammastep/gammastep.nix
    # ../../apps/mpd/mpd.nix
    # ../../apps/mpv/mpv.nix
    # ../../apps/obs/obs.nix
    # ../../apps/zathura/zathura.nix
    # ../../apps/steam/steam.nix
    # ../../apps/python/python.nix
    # ../../apps/pycharm/pycharm.nix
    # ../../apps/tealdeer/tealdeer.nix
  ];

  home.packages = with pkgs; [
    fio
    gh
    gthumb
    xfce.thunar
    xfce.tumbler

    # dev dependencies
    clang
    gnumake
    cmake
    libtool
  ];
}
