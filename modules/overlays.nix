{
  inputs,
  ...
}:
{
  # overlays that should apply to all hosts (to fix build, fix bugs, etc.)
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    # gtksourceview ships its own checkPhase calling `meson test` directly,
    # bypassing the `--timeout-multiplier=0` the meson setup hook adds. Under
    # load, test-language-specs then hits meson's 30s default and is killed,
    # failing the build (gtksourceview -> libspelling -> papers).
    # cf. https://github.com/NixOS/nixpkgs/issues/469034
    (_final: prev: {
      gtksourceview5 = prev.gtksourceview5.overrideAttrs (old: {
        checkPhase =
          builtins.replaceStrings
            [ "meson test --no-rebuild --print-errorlogs" ]
            [ "meson test --no-rebuild --print-errorlogs --timeout-multiplier=0" ]
            old.checkPhase;
      });
    })
    # Restore the grub unicode.pf2 boot-menu font. nixpkgs restructured unifont
    # (unifont.otf moved to share/fonts/opentype/unifont/), so grub's
    # makegrubfonts can no longer find it and the built package ships no .pf2
    # fonts — breaking `bootloader activation` (install-grub.pl can't copy the
    # default font to /boot). Regenerate it from unifont.
    (_final: prev: {
      grub2 = prev.grub2.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ prev.unifont ];
        postInstall = (old.postInstall or "") + ''
          mkdir -p $out/share/grub
          $out/bin/grub-mkfont -s 16 -o $out/share/grub/unicode.pf2 \
            ${prev.unifont}/share/fonts/opentype/unifont/unifont.otf
        '';
      });
    })
    # herdr's vendored Zig-built libghostty-vt bundles compiler_rt/ubsan_rt,
    # whose .eh_frame entries duplicate those of the system libgcc. With
    # binutils 2.46, ld.bfd then aborts herdr's final Rust link with
    # ".eh_frame_hdr refers to overlapping FDEs". Stop bundling those runtimes.
    # Fixed upstream in nixpkgs (commit 277383a8); drop once the flake's
    # nixpkgs includes it.
    (_final: prev: {
      herdr = prev.herdr.overrideAttrs (old: {
        postPatch =
          (old.postPatch or "")
          + prev.lib.optionalString prev.stdenv.hostPlatform.isLinux ''
            substituteInPlace vendor/libghostty-vt/src/build/GhosttyLibVt.zig \
              --replace-fail 'lib.bundle_compiler_rt = true;' 'lib.bundle_compiler_rt = false;' \
              --replace-fail 'lib.bundle_ubsan_rt = true;' 'lib.bundle_ubsan_rt = false;'
          '';
      });
    })
    # (_: super: {
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
    # cf. https://github.com/NixOS/nixpkgs/issues/467164
    # linuxPackages_latest = super.linuxPackages_latest.extend (
    #   _lfinal: lprev: {
    #     xpadneo = lprev.xpadneo.overrideAttrs (old: {
    #       patches = (old.patches or [ ]) ++ [
    #         (super.fetchpatch {
    #           url = "https://github.com/orderedstereographic/xpadneo/commit/233e1768fff838b70b9e942c4a5eee60e57c54d4.patch";
    #           hash = "sha256-HL+SdL9kv3gBOdtsSyh49fwYgMCTyNkrFrT+Ig0ns7E=";
    #           stripLen = 2;
    #         })
    #       ];
    #     });
    #     nvidiaPackages = lprev.nvidiaPackages // {
    #       stable =
    #         if lprev.nvidiaPackages.stable ? open then
    #           lprev.nvidiaPackages.stable
    #           // {
    #             open = lprev.nvidiaPackages.stable.open.overrideAttrs (old: {
    #               patches = (old.patches or [ ]) ++ [
    #                 (super.fetchpatch {
    #                   name = "get_dev_pagemap.patch";
    #                   url = "https://github.com/NVIDIA/open-gpu-kernel-modules/commit/3e230516034d29e84ca023fe95e284af5cd5a065.patch";
    #                   hash = "sha256-BhL4mtuY5W+eLofwhHVnZnVf0msDj7XBxskZi8e6/k8=";
    #                 })
    #               ];
    #             });
    #           }
    #         else
    #           lprev.nvidiaPackages.stable;
    #     };
    #   }
    # );
    # })
  ];
}
