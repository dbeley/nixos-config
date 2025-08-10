{ user, ... }:
{
  sops.defaultSopsFile = "./secrets/secrets.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
}
