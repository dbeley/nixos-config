{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.age = {
    # generate a new age key if none exists
    generateKey = true;
    keyFile = "/var/lib/sops-nix/key.txt";
  };
}
