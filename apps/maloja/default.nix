{ pkgs, ... }:
let
  dataDir = "/var/lib/maloja";
  python = pkgs.python312;

  datauri = python.pkgs.datauri.overridePythonAttrs {
    dontCheckPythonMetadata = true;
  };

  doreah = python.pkgs.buildPythonPackage rec {
    pname = "doreah";
    version = "2.0.1";
    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-vbRtr/KED8qgLMj5bD7oSTpFjrQ3S2pph/QTs/Z0HL8=";
    };
    pyproject = true;
    nativeBuildInputs = with python.pkgs; [ flit-core ];
    propagatedBuildInputs = with python.pkgs; [
      requests
      pyyaml
      jinja2
      bcrypt
    ];
    dontCheckRuntimeDeps = true;
    doCheck = false;
  };

  nimrodel = python.pkgs.buildPythonPackage rec {
    pname = "nimrodel";
    version = "0.8.0";
    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-f9XVuvMXMAgqlDyDsZTF7Afquj9L/0U/4xVsN+VgtW0=";
    };
    pyproject = true;
    nativeBuildInputs = with python.pkgs; [ flit-core ];
    propagatedBuildInputs = with python.pkgs; [
      bottle
      waitress
      doreah
      parse
    ];
    dontCheckRuntimeDeps = true;
    doCheck = false;
  };

  maloja = python.pkgs.buildPythonPackage rec {
    pname = "malojaserver";
    version = "3.2.4";
    src = pkgs.fetchFromGitHub {
      owner = "dbeley";
      repo = "maloja";
      rev = "a34cdcf";
      hash = "sha256-uhI5svwgU7yfIYe3NjnRu4oEvZS6fK/Nag8qonWFzvI=";
    };
    pyproject = true;
    nativeBuildInputs = with python.pkgs; [
      flit-core
      setuptools
      wheel
    ];
    propagatedBuildInputs = [
      python.pkgs.bottle
      python.pkgs.waitress
      doreah
      nimrodel
      python.pkgs.setproctitle
      python.pkgs.jinja2
      python.pkgs.lru-dict
      python.pkgs.psutil
      python.pkgs.sqlalchemy
      datauri
      python.pkgs.python-magic
      python.pkgs.requests
      python.pkgs.toml
      python.pkgs.pyyaml
    ];
    dontCheckRuntimeDeps = true;
    doCheck = false;
  };
in
{
  systemd.services.maloja = {
    description = "Maloja Music Scrobble Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment.MALOJA_DATA_DIRECTORY = dataDir;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${maloja}/bin/maloja run";
      Restart = "on-failure";
      RestartSec = "10";
      DynamicUser = true;
      StateDirectory = "maloja";
      WorkingDirectory = dataDir;
      BindReadOnlyPaths = [ "/run/secrets" ];
    };
    preStart = ''
      mkdir -p ${dataDir}/{config,state,cache,logs}
    '';
  };

  services.nginx.virtualHosts."maloja.navidrome.home" = {
    locations."/".proxyPass = "http://localhost:42010";
    locations."/".proxyWebsockets = true;
  };
}
