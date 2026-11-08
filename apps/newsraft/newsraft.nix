{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.newsraft
    pkgs.wl-clipboard-rs
  ];

  xdg.configFile."newsraft/feeds".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Nextcloud/10-19_Documents/18_Config/18.26_newsraft/feeds";

  xdg.configFile."newsraft/config".text = ''
    bind m exec-quiet setsid ${pkgs.mpv} --terminal=no "%l" &
    bind I exec-quiet setsid sh -c '${pkgs.curl} -sL "$1" | ${pkgs.swayimg} -' newsraft "%l" &
  '';
}
