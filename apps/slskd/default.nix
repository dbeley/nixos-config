{ pkgs, ... }:
{
  systemd.services.slskd = {
    description = "Slskd - Soulseek client daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment.HOME = "/var/lib/slskd";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.slskd}/bin/slskd";
      Restart = "on-failure";
      RestartSec = "10";
      DynamicUser = true;
      StateDirectory = "slskd";
      WorkingDirectory = "/var/lib/slskd";
    };
  };

  services.nginx.virtualHosts."slskd.navidrome.home" = {
    locations."/".proxyPass = "http://localhost:5030";
    locations."/".proxyWebsockets = true;
  };
}
