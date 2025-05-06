{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../home-manager-common-config.nix
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
    ../../apps/autoscreen/autoscreen.nix

    ../../apps/git/git.nix
    ../../apps/lazygit/lazygit.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/ghostty/ghostty.nix
    ../../apps/direnv/direnv.nix
    ../../apps/python/python.nix
    ../../apps/helix/helix.nix
    ../../apps/nnn/nnn.nix
    ../../apps/yazi/yazi.nix
    ../../apps/udiskie/udiskie.nix
    ../../apps/mime/mime.nix
    ../../apps/imv/imv.nix
    ../../apps/bat/bat.nix
    ../../apps/zoxide/zoxide.nix
    ../../apps/zathura/zathura.nix

    ../../apps/firefox/firefox.nix
    # ../../apps/zen-browser/zen-browser.nix
    ../../apps/ungoogled-chromium/ungoogled-chromium.nix
    ../../apps/ledger/ledger.nix
    ../../apps/mpd/mpd.nix
    ../../apps/mpdscrobble/mpdscrobble.nix
    ../../apps/mpv/mpv.nix
    ../../apps/steam/steam.nix
    ../../apps/nextcloud-client/nextcloud-client.nix
  ];

  home.packages = with pkgs; [
    audacity
    beets
    # discord
    # heroic
    # itch
    # musescore
    nautilus
    shotcut
    supersonic
  ];

}
