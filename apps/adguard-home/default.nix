{ lib, ... }:
{
  services.adguardhome = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.resolved.enable = lib.mkForce false;
}
