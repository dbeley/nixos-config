{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../home-manager-common-config.nix
    ../../apps/gnome/gnome.nix
    ../../apps/autoscreen-gnome/autoscreen-gnome.nix
    ../../apps/stylix/stylix.nix

    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/direnv/direnv.nix
    # inputs.nixvim.homeManagerModules.nixvim
    # ../../apps/neovim-nixvim/neovim-nixvim.nix
    ../../apps/helix/helix.nix
    ../../apps/kitty/kitty.nix
    ../../apps/udiskie/udiskie.nix
    ../../apps/bat/bat.nix

    ../../apps/firefox/firefox.nix
    ../../apps/ungoogled-chromium/ungoogled-chromium.nix
    ../../apps/steam/steam.nix
    ../../apps/nextcloud-client/nextcloud-client.nix
  ];

  home.packages = with pkgs; [
    nautilus
    supersonic
  ];

  # disable night light in Gnome
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = lib.mkForce false;
    };
  };
}
