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
      sha256 = "vuTotxRNVwGQjv64k8dKiM5Nz/iA0q+SkhA7CKVJQQw=";
    })
  ];
}
