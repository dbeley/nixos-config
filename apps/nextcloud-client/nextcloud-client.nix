{ pkgs, ... }:
{
  home.packages = with pkgs; [ nextcloud-client ];
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  # The client writes its own XDG autostart entry ("launch on system startup" is
  # enabled in nextcloud.cfg). At login it would start a second instance that
  # races with the systemd user service above, and both instances end up exiting
  # (no tray icon at all). Ship a hidden entry instead: the XDG autostart
  # generator skips it, the systemd service stays the single launcher.
  xdg.configFile."autostart/Nextcloud.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Nextcloud
    Exec=${pkgs.nextcloud-client}/bin/nextcloud --background
    Hidden=true
    X-systemd-skip=true
    X-GNOME-Autostart-enabled=false
  '';

  systemd.user.services.nextcloud-client = {
    Unit = {
      After = pkgs.lib.mkForce [
        "graphical-session.target"
        "network-online.target"
      ];
      Wants = [ "network-online.target" ];
    };
  };
}
