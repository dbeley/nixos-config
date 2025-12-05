{
  user,
  pkgs,
  lib,
  ...
}:
{
  config = {
    services = {
      displayManager = {
        defaultSession = "gnome";
        autoLogin = {
          enable = true;
          user = "${user}";
        };
        gdm.enable = true;
      };
      desktopManager.gnome.enable = true;
      gnome = {
        games.enable = false;
        core-apps.enable = false;
      };
    };

    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;

    # To fix login by fingerprint
    security.pam.services.login.fprintAuth = false;

    environment.gnome.excludePackages = with pkgs; [ gnome-tour ];
    stylix = {
      targets = {
        qt = {
          platform = lib.mkForce "qtct";
        };
      };
    };
  };
}
