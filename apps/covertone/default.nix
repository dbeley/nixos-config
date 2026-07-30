{ inputs, ... }:
{
  imports = [ inputs.covertone.nixosModules.default ];

  services.covertone = {
    enable = true;
    virtualHost = "covertone.home";
  };
}
