{ pkgs, user, ... }:
{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  users.users.${user}.openssh.authorizedKeys.keyFiles = [
    (pkgs.fetchurl {
      url = "https://github.com/dbeley.keys";
      sha256 = "+p0bAnfx/Sx/QAfOIvfg/nbJ3bARptpnTG+Tf6sX9MQ=";
    })
  ];
}
