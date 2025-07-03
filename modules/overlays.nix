{ pkgs, inputs, ... }:
{
  # overlays that should apply to all hosts (to fix build, fix bugs, etc.)
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    (self: super: {
      # # to fix zoom memory leak, working version found here https://github.com/NixOS/nixpkgs/pull/361097
      # zoom-us = super.zoom-us.overrideAttrs (oldAttrs: {
      #   version = "6.2.11.5069";
      #   src = super.fetchurl {
      #     url = "https://zoom.us/client/6.2.11.5069/zoom_x86_64.pkg.tar.xz";
      #     sha256 = "sha256-k8T/lmfgAFxW1nwEyh61lagrlHP5geT2tA7e5j61+qw=";
      #   };
      # });
      # # to fix beets build, cf. https://github.com/NixOS/nixpkgs/pull/370234
      # beets = super.beets.overrideAttrs (oldAttrs: {
      #   patches = oldAttrs.patches ++ [
      #     # Remove after next release.
      #     (super.fetchpatch {
      #       url = "https://github.com/beetbox/beets/commit/bcc79a5b09225050ce7c88f63dfa56f49f8782a8.patch?full_index=1";
      #       hash = "sha256-Y2Q5Co3UlDGKuzfxUvdUY3rSMNpsBoDW03ZWZOfzp3Y=";
      #     })
      #   ];
      # });
      # to fix audacity memory leaks on wayland cf. https://github.com/audacity/audacity/issues/4247
      # audacity = super.audacity.overrideAttrs (oldAttrs: {
      #   postInstall =
      #     (oldAttrs.postInstall or "")
      #     + ''
      #       wrapProgram $out/bin/audacity --set GDK_BACKEND x11
      #     '';
      # });
      # jack1 = super.jack1.overrideAttrs (oldAttrs: {
      #   version = "0.126.0";
      #   src = super.fetchurl {
      #     url = "https://github.com/jackaudio/jack1/releases/download/0.126.0/jack1-0.126.0.tar.gz";
      #     hash = "sha256-eykOnce5JirDKNQe74DBBTyXAT76y++jBHfLmypUReo=";
      #   };
      #   buildInputs = with pkgs; [
      #     alsa-lib
      #     db
      #     libffado
      #     celt_0_7
      #   ];
      # });
      # to fix shell not found error, cf. https://github.com/anthropics/claude-code/issues/330
      # claude-code = super.claude-code.overrideAttrs (oldAttrs: {
      #   version = "0.2.32";
      # });
    })
  ];
}
