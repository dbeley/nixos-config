{
  pkgs,
  user,
  lib,
  stateVersion,
  ...
}:
{
  imports = [
    ../common-user-packages.nix
    ../../apps/gnome/gnome.nix
    ../../apps/autoscreen-gnome/autoscreen-gnome.nix
    ../../apps/stylix/stylix.nix

    ../../apps/git/git.nix
    ../../apps/fish/fish.nix
    ../../apps/tmux/tmux.nix
    ../../apps/direnv/direnv.nix
    # inputs.nixvim.homeManagerModules.nixvim
    # ../../apps/nixvim/nixvim.nix
    ../../apps/helix/helix.nix
    ../../apps/kitty/kitty.nix
    ../../apps/udiskie/udiskie.nix
    ../../apps/bat/bat.nix

    ../../apps/firefox/firefox.nix
    ../../apps/ungoogled-chromium/ungoogled-chromium.nix
    ../../apps/steam/steam.nix
    ../../apps/nextcloud-client/nextcloud-client.nix
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
    supersonic
  ];

  services.mpris-proxy.enable = true;

  # disable night light in Gnome
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = lib.mkForce false;
    };
  };
}
