{ inputs, pkgs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.system};
  opencode-wrapped = pkgs.symlinkJoin {
    name = "opencode-wrapped";
    paths = [ llm.opencode ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/opencode --set OPENCODE_ENABLE_EXA 1
    '';
  };
in
{
  home.packages = [ opencode-wrapped ];

  xdg.configFile."opencode/opencode.json" = {
    force = true;
    text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = false;
      share = "disabled";
      model = "opencode-go/deepseek-v4-pro";
      provider.opencode-go.options.apiKey = "{file:/run/secrets/opencode-go-api-key}";
      permission = {
        edit = "allow";
        bash = "allow";
      };
    };
  };

  systemd.user.services.opencode-server = {
    Unit = {
      Description = "OpenCode Web Server";
      After = [ "network.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart =
        let
          startScript = pkgs.writeShellScript "opencode-server-start" ''
            if [ -f /run/secrets/opencode-server-password ]; then
              export OPENCODE_SERVER_PASSWORD=$(cat /run/secrets/opencode-server-password)
            fi
            exec ${opencode-wrapped}/bin/opencode web --hostname 0.0.0.0 --port 80
          '';
        in
        "${startScript}";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
