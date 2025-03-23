{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../home-manager-common-config.nix
    inputs.hyprland.homeManagerModules.default
    ../../apps/hyprland/hyprland.nix
    ../../apps/waybar/waybar.nix
    ../../apps/tofi/tofi.nix
    ../../apps/mako/mako.nix
    ../../apps/gammastep/gammastep.nix
    ../../apps/autoscreen/autoscreen.nix
    ../../apps/autoscreen-gaming/autoscreen-gaming.nix
    # ../../apps/gnome/gnome.nix
    ../../apps/stylix/stylix.nix

    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/ghostty/ghostty.nix
    ../../apps/direnv/direnv.nix
    ../../apps/python/python.nix
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
    ../../apps/ungoogled-chromium/ungoogled-chromium.nix
    ../../apps/qutebrowser/qutebrowser.nix
    ../../apps/ledger/ledger.nix
    ../../apps/mpd/mpd.nix
    ../../apps/mpdscrobble/mpdscrobble.nix
    ../../apps/mpv/mpv.nix
    ../../apps/obs/obs.nix
    ../../apps/steam/steam.nix
    ../../apps/pycharm/pycharm.nix
    ../../apps/nextcloud-client/nextcloud-client.nix
    ../../apps/tealdeer/tealdeer.nix
  ];

  home.packages = with pkgs; [
    audacity
    beets
    borgbackup
    borgmatic
    # fio
    # gh
    # gthumb
    heroic
    # hugo
    shotcut
    supersonic
    xfce.thunar
    xfce.tumbler

    discord
    # element-desktop

    # dev dependencies
    # clang
    # gnumake
    # cmake
    # libtool
  ];
}
