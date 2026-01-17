{ user, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    # Secrets can be defined here when needed:
    # secrets = {
    #   example-secret = {};
    # };
  };
}
