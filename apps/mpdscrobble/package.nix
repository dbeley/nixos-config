{
  lib,
  python,
  fetchFromGitHub,
}:
with python.pkgs;
buildPythonApplication rec {
  pname = "mpdscrobble";
  # PyPI is stuck on 0.3.5, which predates the crash-recovery and
  # single-currentsong fixes: track upstream main instead.
  version = "0.3.5-unstable-2026-08-03";

  src = fetchFromGitHub {
    owner = "dbeley";
    repo = "mpdscrobble";
    rev = "0b89f869bf28a6a44f872ae59c5ece7023e81b36";
    hash = "sha256-ijRsXivszlwGE1+23Do6eR1psQ9d+6TdZOLqc0gzHQI=";
  };

  propagatedBuildInputs = [
    python-mpd2
    pylast
    httpx
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "mpdscrobble" ];
  pyproject = true;
  build-system = [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/dbeley/mpdscrobble";
    description = "A simple Last.fm scrobbler for MPD.";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
