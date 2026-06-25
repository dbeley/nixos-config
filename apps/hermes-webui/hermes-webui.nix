{ inputs, ... }:
{
  imports = [ inputs.hermes-webui-nix.homeModules.default ];
  services.hermes-webui = {
    enable = true;
    passwordFile = "$HOME/.config/hermes/webui-password";
  };
}
