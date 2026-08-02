{ user, ... }:
{
  services.hermes-webui = {
    enable = true;
    port = 80;
    passwordFile = "$HOME/.config/hermes/webui-password";
  };
  sops.secrets = {
    hermes-webui-password = {
      path = "/home/${user}/.config/hermes/webui-password";
      sopsFile = ../../secrets/hermes.yaml;
    };
  };
}
