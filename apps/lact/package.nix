{ lib, rustPlatform, fetchFromGitHub, pkg-config, gtk4, libadwaita, vulkan-loader, libdrm, clang, }:

rustPlatform.buildRustPackage rec {
  pname = "lact";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ilya-zlobintsev";
    repo = "LACT";
    rev = "v${version}";
    hash = lib.fakeSha256;
  };

  cargoHash = lib.fakeSha256;

  nativeBuildInputs = [ pkg-config clang ];
  buildInputs = [ gtk4 libadwaita vulkan-loader libdrm ];

  cargoBuildFlags = [ "--package" "lact" "--features" "adw" ];

  meta = with lib; {
    description = "Linux AMD control tool";
    homepage = "https://github.com/ilya-zlobintsev/LACT";
    license = licenses.gpl3Plus;
  };
}
