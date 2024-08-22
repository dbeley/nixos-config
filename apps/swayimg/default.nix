{ pkgs, ... }:
{
   nixpkgs.overlays = [
    (self: super: {
      swayimg = super.swayimg.overrideAttrs (oldAttrs: {
        version = "3.1";
        src = super.fetchurl {
          url ="https://github.com/artemsen/swayimg/archive/refs/tags/v3.1.tar.gz";
          sha256 = "sha256-DGy3ES4WDhoppWbJLFt8b4xd7TSqC5QJPNTbw77qcGo=";
        };
      # nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      #   super.pkg-config
      #   super.meson
      # ];
      # buildInputs = (oldAttrs.buildInputs or []) ++ [
      #   super.giflib
      #   super.libjpeg
      #   super.libpng
      #   super.libwebp
      # ];
      });
    })
  ];
}
