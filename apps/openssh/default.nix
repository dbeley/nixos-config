{
  user,
  pkgs,
  lib,
  ...
}:

let
  authorizedKeys = pkgs.fetchurl {
    url = "https://github.com/dbeley.keys";
    sha256 = "vuTotxRNVwGQjv64k8dKiM5Nz/iA0q+SkhA7CKVJQQw=";
  };
in
{
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    # settings.PermitRootLogin = "yes";
  };
  users.users.${user}.openssh.authorizedKeys.keys = lib.splitString "\n" (
    builtins.readFile authorizedKeys
  );
}
