{
  lib,
  pkgs,
  user,
  inputs,
  ...
}:
let
  secretsDir = "/home/${user}/.secrets";
  documentsDir = "/home/${user}/.openclaw/documents";
  configDir = "/home/${user}/.config/openclaw";
in
{
  imports = [ inputs.nix-openclaw.homeManagerModules.openclaw ];

  programs.openclaw = {
    enable = true;
    documents = documentsDir;
    config = {
      gateway = {
        mode = "local";
      };
      channels = {
        telegram = {
          tokenFile = "${secretsDir}/telegram-bot-token";
          # Placeholder - will be patched by activation script
          allowFrom = [ 0 ];
        };
      };
    };
  };

  # Patch the config with the real telegram user ID from secrets file
  home.activation.patchOpenclawConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f "${secretsDir}/telegram-user-id" ]; then
      USER_ID=$(cat "${secretsDir}/telegram-user-id" | tr -d '[:space:]')
      CONFIG_FILE="${configDir}/config.json"
      if [ -f "$CONFIG_FILE" ]; then
        ${pkgs.jq}/bin/jq --argjson uid "$USER_ID" '.channels.telegram.allowFrom = [$uid]' "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
        mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
      fi
    fi
  '';

  # Ensure the ANTHROPIC_API_KEY is set for the systemd service
  systemd.user.services.openclaw-gateway.Service.EnvironmentFile = lib.mkForce [
    "${secretsDir}/openclaw-env"
  ];
}
