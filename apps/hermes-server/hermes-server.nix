{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # numtide/llm-agents.nix ships hermes-agent without its bundled plugins/
  # (plugin.yaml manifests) and never sets HERMES_BUNDLED_PLUGINS, so web
  # search providers (exa, ddgs, ...) never register. Patch the package to
  # install plugins/ and point the wrapper at it.
  hermes-agent = inputs.llm-agents.packages.${pkgs.system}.hermes-agent.overrideAttrs (old: {
    postInstall = old.postInstall + ''
      cp -r ${old.src}/plugins $out/share/hermes/plugins
    '';
    makeWrapperArgs = old.makeWrapperArgs ++ [
      "--set"
      "HERMES_BUNDLED_PLUGINS"
      "${placeholder "out"}/share/hermes/plugins"
    ];
  });
in
{
  imports = [ inputs.hermes-webui-nix.homeModules.default ];
  services.hermes-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 8787;
    passwordFile = "${config.home.homeDirectory}/.config/hermes/webui-password";
    environmentFile = config.sops.secrets."hermes-webui-env".path;
    agentPackage = hermes-agent;
  };
  systemd.user.services.hermes-webui.Service.Environment = lib.mkAfter [
    "HERMES_BUNDLED_PLUGINS=${hermes-agent}/share/hermes/plugins"
  ];
  sops.secrets = {
    hermes-webui-password = {
      path = "${config.home.homeDirectory}/.config/hermes/webui-password";
      sopsFile = ../../secrets/hermes.yaml;
    };
    hermes-webui-env = {
      sopsFile = ../../secrets/hermes.yaml;
    };
  };
}
