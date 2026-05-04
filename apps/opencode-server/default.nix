{
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;
  networking.firewall.allowedTCPPorts = [ 80 ];
  users.users.david.linger = true;
}
