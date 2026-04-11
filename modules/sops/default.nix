{
  user,
  ...
}:
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    secrets = { };
  };
}
