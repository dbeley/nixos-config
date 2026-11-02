{ inputs, ... }: {
  imports = [ inputs.cairn.nixosModules.cairn ];

  services.cairn = {
    enable = true;
    domain = "hermes.home";

    kiwix = {
      enable = true;
      zimFiles = {
        wikipedia = {
          filename = "wikipedia_en_top_maxi_2026-09.zim";
          url = "https://lb.download.kiwix.org/zim/wikipedia/wikipedia_en_top_maxi_2026-09.zim";
          sha256 = "sha256-fAjSp1V+9+PadRu0KdCB4cfIlx5Q/uT+8JcCGgPqawo=";
        };
      };
    };

    ollama = {
      enable = true;
      gpu = null;
      models = [ ];
    };

    open-webui.enable = true;
    cyberchef.enable = true;

    caddy = {
      enable = true;
      port = 8080;
    };
  };
  networking.firewall.allowedTCPPorts = [
    8080
    9090
    9091
  ];
}
