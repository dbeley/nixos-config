{ user, ... }:
{
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
      defaultSession = "gnome";
      autoLogin = {
        enable = true;
        user = "${user}";
      };
    };
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
