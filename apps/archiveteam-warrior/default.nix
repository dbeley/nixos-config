{ user, ... }:
{
  systemd.tmpfiles.rules = [
    "d /var/lib/archiveteam-warrior 0755 ${user} users -"
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers.archiveteam-warrior = {
      image = "atdr.meo.ws/archiveteam/warrior-dockerfile";
      ports = [ "8001:8001" ];
      volumes = [ "/var/lib/archiveteam-warrior:/downloader:Z" ];
      environment = {
        DOWNLOADER = "dbeley";
        SELECTED_PROJECT = "auto";
      };
      autoStart = true;
    };
  };
}
