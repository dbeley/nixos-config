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
    rev = "f59bf1005a77041f3a85a6cd089d02e6545eaea7";
    hash = "sha256-cl6D03Zf7xeulOKYuQxrPML/cZO4SXzSnWEUxJd5WPs=";
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
