{ user, ... }:
{
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "gamescope";
  services.xserver.displayManager.session = [{
    manage = "desktop";
    name = "gamescope";
    start = "exec $HOME/.xsession";
  }];
  services.xserver.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamescope.enable = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "${user}";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
