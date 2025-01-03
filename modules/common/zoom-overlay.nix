{
  nixpkgs.overlays = [
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
