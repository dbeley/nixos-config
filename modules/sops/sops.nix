{
  pkgs,
  user,
  ...
}:
{
  home.packages = [ pkgs.sops ];
  sops = {
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
  };
}
