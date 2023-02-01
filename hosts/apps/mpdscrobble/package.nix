{ lib, python3 }:

with python3.pkgs;
buildPythonApplication rec {
  pname = "mpdscrobble";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "JwgiPX7j5F+Ny1MayO4+ZcX2hdiy6/RVMyGSRtPgb+Y=";
  };

  propagatedBuildInputs = [ mpd2 pylast httpx ];

  # No tests included
  doCheck = false;
  pythonImportsCheck = [ "mpdscrobble" ];

  meta = with lib; {
    homepage    = "https://github.com/dbeley/mpdscrobble";
    description = "A simple Last.fm scrobbler for MPD.";
    license     = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
  };
}
