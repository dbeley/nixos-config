{ pkgs, ... }:
{
  home.packages = with pkgs; [ nextcloud-client ];
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  systemd.user.services.nextcloud-client = {
    Unit = {
      After = pkgs.lib.mkForce "graphical-session.target";
    };
  };
}
