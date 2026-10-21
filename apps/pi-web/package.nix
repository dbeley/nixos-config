# pi-web publishes a prebuilt Next.js app on npm, so there is no build step
# here. To bump the version:
#
#   1. update `version` below and the tarball `hash`
#      (nix hash file <(curl -sL <tarball url>) --type sha256)
#   2. regenerate package-lock.json from the new tarball, without devDependencies:
#        mkdir x && tar xzf pi-web-<v>.tgz -C x --strip-components=1
#        jq 'del(.devDependencies)' x/package.json > p && mv p x/package.json
#        (cd x && npm install --package-lock-only --ignore-scripts)
#        cp x/package-lock.json apps/pi-web/package-lock.json
#   3. set `npmDepsHash` to lib.fakeHash, build, and copy the reported hash back
{
  lib,
  buildNpmPackage,
  coreutils,
  fetchurl,
  jq,
  nodejs_22,
  runCommand,
  runtimeShell,
}:

let
  version = "0.12.2";

  src = runCommand "pi-web-${version}-src" { nativeBuildInputs = [ jq ]; } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@agegr/pi-web/-/pi-web-${version}.tgz";
        hash = "sha256-Fq/g7h/2O5VCmtc4AtE+U6L4MXJGQT7Ri5L3s2/YbGo=";
      }
    } -C $out --strip-components=1
    jq 'del(.devDependencies)' $out/package.json > $out/package.json.new
    mv $out/package.json.new $out/package.json
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage {
  pname = "pi-web";
  inherit version src;

  npmDepsHash = "sha256-K1ZBtK8YFOZNJIAh+Hm760RrFCt/Yo+89mUzsBZinQk=";
  nodejs = nodejs_22;

  dontNpmBuild = true;

  # pi-web rewrites .next/prerender-manifest.json on startup to replace the
  # preview-mode secrets baked into the published tarball. Leaving the published
  # previewModeId in place lets a client skip the password gate through the
  # x-prerender-revalidate header. The Nix store is read-only, so the launcher
  # below runs the app from a writable per-version directory instead: a copy of
  # the app itself (small) plus a symlink to node_modules (large, immutable).
  postInstall = ''
    rm -f $out/bin/pi-web
    cat > $out/bin/pi-web <<EOF
    #!${runtimeShell}
    set -eu
    PATH=${lib.makeBinPath [ coreutils ]}:\$PATH
    export PI_WEB_SKIP_VERSION_CHECK="\''${PI_WEB_SKIP_VERSION_CHECK:-1}"

    pkg="$out/lib/node_modules/@agegr/pi-web"
    state="\''${XDG_STATE_HOME:-\$HOME/.local/state}/pi-web/${version}"

    if [ ! -f "\$state/.ready" ]; then
      tmp="\$state.tmp.\$\$"
      rm -rf "\$tmp"
      mkdir -p "\$tmp" "\$(dirname "\$state")"
      cp -R "\$pkg/bin" "\$pkg/.next" "\$pkg/public" \
        "\$pkg/package.json" "\$pkg/next.config.ts" "\$tmp/"
      ln -s "\$pkg/node_modules" "\$tmp/node_modules"
      chmod -R u+w "\$tmp"
      : > "\$tmp/.ready"
      rm -rf "\$state"
      mv "\$tmp" "\$state"
    fi

    exec ${lib.getExe nodejs_22} "\$state/bin/pi-web.js" "\$@"
    EOF
    chmod +x $out/bin/pi-web
  '';

  meta = {
    description = "Browser UI for the pi coding agent";
    homepage = "https://github.com/agegr/pi-web";
    license = lib.licenses.mit;
    mainProgram = "pi-web";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
