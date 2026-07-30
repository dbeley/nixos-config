{ inputs, ... }:
{
  imports = [ inputs.covertone.nixosModules.default ];

  services.covertone = {
    enable = true;
    virtualHost = "covertone.navidrome.home";
    server = "http://navidrome.home";
    username = "alice";
    password = "...";
  };
}
