{ pkgs, inputs, ... }:
let
  covertone-src = inputs.covertone.outPath;
  covertone-dist = pkgs.stdenv.mkDerivation {
    name = "covertone";
    src = covertone-src;
    pnpmDeps = pkgs.fetchPnpmDeps {
      pname = "covertone";
      src = covertone-src;
      hash = "sha256-sJ/2e7RMDnJoHCT+aBYPuFaalPi7bY/nseTnmseFaF4=";
      fetcherVersion = 4;
    };
    nativeBuildInputs = [
      pkgs.nodejs_22
      pkgs.pnpm
      pkgs.pnpmConfigHook
    ];
    installPhase = ''
      pnpm build
      cp -r dist $out
    '';
  };
in
{
  services.nginx.virtualHosts."covertone.navidrome.home" = {
    root = covertone-dist;
    locations = {
      "/" = {
        tryFiles = "$uri $uri/ /index.html";
      };
      "/assets/" = {
        extraConfig = ''
          expires 1y;
          add_header Cache-Control "public, immutable";
        '';
      };
      "= /sw.js" = {
        extraConfig = ''
          add_header Cache-Control "no-cache";
        '';
      };
    };
  };
}
