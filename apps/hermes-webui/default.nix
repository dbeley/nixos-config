{ inputs, user, ... }:
{
  imports = [ inputs.hermes-webui-nix.nixosModules.default ];
  services.hermes-webui = {
    enable = true;
    inherit user;
  };
}
