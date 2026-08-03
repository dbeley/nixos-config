{ config, inputs, ... }:
{
  imports = [ inputs.hermes-webui-nix.homeModules.default ];
  services.hermes-webui = {
    enable = true;
    port = 80;
    passwordFile = "${config.home.homeDirectory}/.config/hermes/webui-password";
  };
  sops.secrets = {
    hermes-webui-password = {
      path = "${config.home.homeDirectory}/.config/hermes/webui-password";
      sopsFile = ../../secrets/hermes.yaml;
    };
  };
}
