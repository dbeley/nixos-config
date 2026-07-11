{ inputs, ... }: {
  imports = [ inputs.cairn.nixosModules.cairn ];

  services.cairn = {
    enable = true;
    domain = "hermes.home";

    kiwix = {
      enable = true;
      zimFiles = {
        wikipedia = {
          filename = "wikipedia_en_top_maxi_2026-06.zim";
          url = "https://lb.download.kiwix.org/zim/wikipedia/wikipedia_en_top_maxi_2026-06.zim";
          sha256 = "sha256-02cwhdjz0ccm387mwiad9914hx3q3f8x2ylisqd58v82krc5si8v=";
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
