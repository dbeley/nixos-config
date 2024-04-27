{ user, ... }:
{
  services.displayManaer = {
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
}
