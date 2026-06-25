{
  user,
  ...
}:
{
  services.hermes-webui = {
    enable = true;
    port = 80;
    inherit user;
  };
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;
}
