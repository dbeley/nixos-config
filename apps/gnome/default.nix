{ user, pkgs, ... }:
{
  services.displayManager = {
    defaultSession = "gnome";
    autoLogin = {
      enable = true;
      user = "${user}";
    };
    gdm.enable = true;
  };
  services.desktopManager.gnome.enable = true;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # To fix login by fingerprint
  security.pam.services.login.fprintAuth = false;

  services.gnome = {
    games.enable = false;
    core-apps.enable = false;
  };
  environment.gnome.excludePackages = with pkgs; [ gnome-tour ];
}
