{ lib, python3 }:
with python3.pkgs;
buildPythonApplication rec {
  pname = "mpdscrobble";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "jOmJJzUWfiLOlpVVPKCsMCQ7rEqjBAUgrP2jdRyWmjc=";
  };

  propagatedBuildInputs = [
    mpd2
    pylast
    httpx
  ];

  # No tests included
  doCheck = false;
  pythonImportsCheck = [ "mpdscrobble" ];

  meta = with lib; {
    homepage = "https://github.com/dbeley/mpdscrobble";
    description = "A simple Last.fm scrobbler for MPD.";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
