{
  pkgs,
  ...
}:
{
  imports = [
    ../home-manager-common-config.nix
    ../../apps/sway/sway.nix
    ../../apps/swaylock/swaylock.nix
    ../../apps/waybar/waybar.nix
    ../../apps/tofi/tofi.nix
    ../../apps/mako/mako.nix
    ../../apps/gammastep/gammastep.nix
    ../../apps/autoscreen/autoscreen.nix
    ../../apps/autoscreen-gaming/autoscreen-gaming.nix
    ../../apps/stylix/stylix.nix
    ../../apps/python/python.nix

    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/ghostty/ghostty.nix
    ../../apps/direnv/direnv.nix
    ../../apps/helix/helix.nix
    ../../apps/nnn/nnn.nix
    ../../apps/udiskie/udiskie.nix
    ../../apps/mime/mime.nix
    ../../apps/imv/imv.nix
    ../../apps/bat/bat.nix
    ../../apps/zoxide/zoxide.nix
    ../../apps/zathura/zathura.nix

    ../../apps/firefox/firefox.nix
    ../../apps/ungoogled-chromium/ungoogled-chromium.nix
    ../../apps/ledger/ledger.nix
    ../../apps/mpd/mpd.nix
    ../../apps/mpdscrobble/mpdscrobble.nix
    ../../apps/mpv/mpv.nix
    ../../apps/steam/steam.nix
    ../../apps/nextcloud-client/nextcloud-client.nix
    ../../apps/tealdeer/tealdeer.nix
  ];

  home.packages = with pkgs; [
    beets
    borgbackup
    borgmatic
    # fio
    # gh
    # gthumb
    # hugo
    supersonic
    # ungoogled-chromium
    xfce.thunar
    xfce.tumbler

    # discord
    # element-desktop

    # dev dependencies
    # clang
    # gnumake
    # cmake
    # libtool
  ];
}
