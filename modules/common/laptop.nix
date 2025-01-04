{
  imports = [ ../../apps/light/light.nix ];

  # nixpkgs.overlays = [
  #   (self: super: {
  #     blueman = super.blueman.overrideAttrs (oldAttrs: {
  #       version = "2.3.5";
  #       src = super.fetchurl {
  #         url = "https://github.com/blueman-project/blueman/releases/download/2.3.5/blueman-2.3.5.tar.xz";
  #         sha256 = "sha256-stIa/fd6Bs2G2vVAJAb30qU0WYF+KeC+vEkR1PDc/aE=";
  #       };
  #     });
  #   })
  # ];
  powerManagement.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        # ControllerMode = "dual";
        JustWorksRepairing = "always";
        # FastConnectable = "true";
        # Class = "0x000100";
      };
      # Policy = {
      #   ReconnectIntervals = "1,1,2,3,5,8,13,21,34,55";
      #   AutoEnable = "true";
      # };
    };
  };
  services.blueman.enable = true;
  # services.tlp.enable = true;
  services.logind = {
    lidSwitch = "ignore";
    powerKey = "ignore";
  };
}
