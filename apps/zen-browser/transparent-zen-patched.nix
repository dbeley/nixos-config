{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs,
  zip,
}:

let
  version = "0.9.4-patched-1";
in
buildNpmPackage {
  pname = "transparent-zen";
  inherit version;

  src = fetchFromGitHub {
    owner = "dbeley";
    repo = "transparent-zen";
    rev = "fix/respect-ignore-list-on-styles-injection";
    hash = "sha256-P9B6Q9PuHLTDj12DSYAEqv/4p3ijI5la1EsQSLFqPMU=";
  };

  npmDepsHash = "sha256-kaQMGFZgNFihglS8J492xdqxiu3FB+q83cXz+gQIMMc=";

  nativeBuildInputs = [
    nodejs
    zip
  ];

  # Disable the npm build hook — we handle building ourselves
  dontNpmBuild = true;

  buildPhase = ''
    runHook preBuild

    # Build the extension (skip vue-tsc type check, just vite)
    npx vite build

    # Package as XPI — preserve dist/ prefix to match manifest.json paths
    cd "$NIX_BUILD_TOP/source"
    ${zip}/bin/zip -r "$TMPDIR/transparent-zen.xpi" \
      dist/ styles/ assets/ data/ manifest.json \
      -x 'dist/*.map' > /dev/null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 "$TMPDIR/transparent-zen.xpi" \
      "$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/transparent-zen.xpi"

    runHook postInstall
  '';

  meta = {
    description = "Applies custom styles to make your favorite websites transparent (patched to respect ignore list on tab switch)";
    homepage = "https://github.com/dbeley/transparent-zen";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
