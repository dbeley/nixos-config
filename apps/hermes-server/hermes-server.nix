{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.hermes-webui-nix.homeModules.default ];
  services.hermes-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 8787;
    passwordFile = "${config.home.homeDirectory}/.config/hermes/webui-password";
    environmentFile = config.sops.secrets."hermes-webui-env".path;
    agentPackage = inputs.llm-agents.packages.${pkgs.system}.hermes-agent;
  };
  sops.secrets = {
    hermes-webui-password = {
      path = "${config.home.homeDirectory}/.config/hermes/webui-password";
      sopsFile = ../../secrets/agents.yaml;
    };
    hermes-webui-env = {
      sopsFile = ../../secrets/agents.yaml;
    };
  };
}
