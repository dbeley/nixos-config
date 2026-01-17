{ user, ... }:
{
  services.qbittorrent = {
    enable = true;
    inherit user;
    group = "users";
    openFirewall = true;
  };
}
