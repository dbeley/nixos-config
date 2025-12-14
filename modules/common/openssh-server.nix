{ pkgs, user, ... }:
{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  users.users.${user}.openssh.authorizedKeys.keyFiles = [
    (pkgs.fetchurl {
      url = "https://github.com/dbeley.keys";
      sha256 = "m3UIHF7Vp6Tut5RAgXcZ9+gnu6V0a/2doEVpIOij+kw=";
    })
  ];
}
