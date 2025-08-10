{
  pkgs,
  inputs,
  lib,
  user,
  ...
}:
let
  ageKeyFile = "/home/${user}/.config/sops/age/keys.txt";
  secretsFile = ../../secrets/secrets.yaml;
  hasAgeKey = builtins.pathExists ageKeyFile;
  hasSecrets = builtins.pathExists secretsFile;
in
{
    imports = lib.optional hasAgeKey inputs.sops-nix.nixosModules.sops;

    environment.systemPackages = with pkgs; [
      sops
      age
      ssh-to-age
    ];
  }
  // lib.optionalAttrs hasAgeKey {
    sops = {
      age.keyFile = ageKeyFile;
    }
    // lib.optionalAttrs hasSecrets {
      defaultSopsFile = secretsFile;
      secrets = {
        "ssh/id_ed25519" = {
          path = "/home/${user}/.ssh/id_ed25519";
          format = "binary";
          owner = user;
          group = "users";
          mode = "0600";
        };
        "nextcloud/password" = {
          path = "/home/${user}/.config/nextcloud/credentials";
          owner = user;
          group = "users";
          mode = "0600";
        };
      };
    };
  }
