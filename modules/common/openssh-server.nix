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
      sha256 = "D8/0HhejnFvo9N39k0OW05Apigl2xN84a10cu5c2SEA=";
    })
  ];
}
