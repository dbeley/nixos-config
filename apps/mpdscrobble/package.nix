{ lib, python }:
with python.pkgs;
buildPythonApplication rec {
  pname = "mpdscrobble";
  version = "0.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0doBCHXtIrcn50oKV3wThG9wjvRYNKSC9aXGBPIV7bM=";
  };

  propagatedBuildInputs = [
    python-mpd2
    pylast
    httpx
  ];

  # No tests included
  doCheck = false;
  pythonImportsCheck = [ "mpdscrobble" ];
  pyproject = true;
  build-system = [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/dbeley/mpdscrobble";
    description = "A simple Last.fm scrobbler for MPD.";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
