{ fetchpatch, ... }:
{
  # overlays that should apply to all hosts (to fix build, fix bugs, etc.)
  nixpkgs.overlays = [
    (self: super: {
      python3Packages = super.python3Packages // {
        # to fix beets build, cf. https://github.com/NixOS/nixpkgs/pull/370234
        beets-stable = super.python3Packages.beets-stable.overrideAttrs (oldAttrs: {
          extraPatches = oldAttrs.extraPatches ++ [
            # Remove after next release.
            (fetchpatch {
              url = "https://github.com/beetbox/beets/commit/bcc79a5b09225050ce7c88f63dfa56f49f8782a8.patch?full_index=1";
              hash = "sha256-Y2Q5Co3UlDGKuzfxUvdUY3rSMNpsBoDW03ZWZOfzp3Y=";
            })
          ];
        });
      };
    })
    # to fix zoom memory leak, working version found here https://github.com/NixOS/nixpkgs/pull/361097
    (self: super: {
      zoom-us = super.zoom-us.overrideAttrs (oldAttrs: {
        version = "6.2.11.5069";
        src = super.fetchurl {
          url = "https://zoom.us/client/6.2.11.5069/zoom_x86_64.pkg.tar.xz";
          sha256 = "sha256-k8T/lmfgAFxW1nwEyh61lagrlHP5geT2tA7e5j61+qw=";
        };
      });
    })
  ];
}
