{ user, pkgs, ... }:
{
  services.displayManager = {
    defaultSession = "gnome";
    autoLogin = {
      enable = true;
      user = "${user}";
    };
  };
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
    };
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # To fix login by fingerprint
  security.pam.services.login.fprintAuth = false;

  services.gnome = {
    games.enable = false;
    core-utilities.enable = false;
  };
  programs.gnome-terminal.enable = false;
  environment.gnome.excludePackages = with pkgs; [ gnome-tour ];
}
