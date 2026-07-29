{
  user,
  ...
}:
let
  nfsServer = "omv.home";
  nfsExport = "/WDC14_2";
  nfsMount = "/mnt/nfs/WDC14_2";
in
{
  fileSystems.${nfsMount} = {
    device = "${nfsServer}:${nfsExport}";
    fsType = "nfs";
    options = [
      "_netdev"
      "nofail"
      "hard"
      "timeo=60"
      "retrans=3"
    ];
  };

  systemd.tmpfiles.settings."immich-nfs-symlink" = {
    "/home/${user}/nfs".L.argument = "/mnt/nfs";
  };

  services.immich = {
    enable = true;
    openFirewall = true;
    # Listen on all interfaces so the VM is reachable from the LAN
    # (default is "localhost", which would block remote access despite the firewall port).
    host = "0.0.0.0";
    mediaLocation = "${nfsMount}/Immich";
    inherit user;
    group = "users";
    # Run as `david` so NFS writes match OMV ownership. Peer-socket auth then
    # needs a matching PG role/db, both auto-created by the module only when
    # their names coincide (the module asserts db name == user name).
    database.user = user;
    database.name = user;
  };

  systemd.services.immich-server = {
    requires = [ "mnt-nfs-WDC14_2.mount" ];
    after = [
      "mnt-nfs-WDC14_2.mount"
      "network-online.target"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 2283 ];
}
