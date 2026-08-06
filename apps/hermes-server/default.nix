{
  config,
  pkgs,
  inputs,
  user,
  domain,
  ...
}:
let
  llm = inputs.llm-agents.packages.${pkgs.system};
  # hermes-agent 2026.8.3 ships tools/daemon_pool.py mirroring CPython 3.8-3.13,
  # which reads ThreadPoolExecutor._initializer/_initargs; Python 3.14 removed
  # those attributes (_worker now takes a context object). Patch it to the 3.14
  # API so DaemonThreadPoolExecutor doesn't crash during parallel LLM calls.
  hermesAgent = llm.hermes-agent.overridePythonAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      python3 -c '
        import pathlib
        p = pathlib.Path("tools/daemon_pool.py")
        s = p.read_text()
        old = "self._work_queue," + "\n" + " " * 20 + "self._initializer," + "\n" + " " * 20 + "self._initargs," + "\n" + " " * 16 + ")," + "\n" + " " * 16 + "daemon=True,"
        new = "self._create_worker_context()," + "\n" + " " * 20 + "self._work_queue," + "\n" + " " * 16 + ")," + "\n" + " " * 16 + "daemon=True,"
        assert old in s, "daemon_pool.py: expected CPython 3.8-3.13 worker-args pattern not found"
        p.write_text(s.replace(old, new, 1))
      '
    '';
  });

  # The WebUI needs a python able to run the agent (HERMES_WEBUI_PYTHON).
  # The llm-agents hermes-agent wrapper embeds its dependency-complete python
  # as HERMES_PYTHON; expose it so the upstream module can point at it.
  hermesVenv = pkgs.runCommand "hermes-agent-venv" { } ''
    mkdir -p $out/bin
    py="$(
      sed -n "s/.*HERMES_PYTHON='\([^']*\)'.*/\1/p" ${hermesAgent}/bin/hermes |
        head -n1
    )"
    ln -s "$py" $out/bin/python3
    test -x "$out/bin/python3"
  '';
in
{
  imports = [ inputs.hermes-webui.nixosModules.default ];

  services.hermes-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 8787;
    inherit user;
    group = "users";
    hermesHome = "/home/${user}/.hermes";
    agent.dir = "${hermesAgent}/${pkgs.python3.sitePackages}";
    agent.python = "${hermesVenv}/bin/python3";
    environmentFiles = [
      config.sops.secrets.hermes-webui-password.path
      config.sops.secrets.exa-api-key.path
    ];
    # systemd gives the unit a minimal PATH (coreutils/findutils/...), so the
    # agent's terminal tool can't find bash and _find_bash() falls back to
    # $SHELL=fish, breaking its bash-syntax wrapper. Point it at the system
    # environment and force bash.
    extraEnvironment = {
      PATH = "/run/current-system/sw/bin";
      SHELL = "${pkgs.bash}/bin/bash";
    };
  };

  sops.secrets = {
    hermes-webui-password = {
      sopsFile = ../../secrets/hermes.yaml;
      group = "users";
    };
    exa-api-key = {
      sopsFile = ../../secrets/hermes.yaml;
      group = "users";
    };
  };

  environment.systemPackages = [
    hermesAgent
    pkgs.git
    pkgs.python3
  ];

  services.nginx = {
    enable = true;
    virtualHosts."hermes.${domain}" = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8787";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
