{ pkgs, ... }: {
  home.packages = with pkgs; [ bat ];
  xdg.configFile."bat/config".source = ./config;
}
