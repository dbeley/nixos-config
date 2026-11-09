{
  config,
  lib,
  pkgs,
  ...
}:
let
  chawan = lib.getExe pkgs.chawan;
  mpv = lib.getExe pkgs.mpv;

  openImage = pkgs.writeShellApplication {
    name = "newsraft-open-image";
    runtimeInputs = [
      pkgs.curl
      pkgs.file
      pkgs.libnotify
      pkgs.swayimg
    ];
    text = ''
      url=$1
      tmp=$(mktemp)
      trap 'rm -f "$tmp"' EXIT

      if ! curl --fail --silent --location --max-time 30 --output "$tmp" "$url"; then
        notify-send newsraft "Failed to download $url"
        exit 1
      fi

      mime=$(file --brief --mime-type "$tmp")
      case $mime in
        image/*) swayimg "$tmp" ;;
        *) notify-send newsraft "$mime is not an image - prefix I with the index of an image link" ;;
      esac
    '';
  };
in
{
  home.packages = [
    openImage
    pkgs.chawan
    pkgs.newsraft
    pkgs.wl-clipboard-rs
  ];

  xdg.configFile."newsraft/feeds".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Nextcloud/10-19_Documents/18_Config/18.26_newsraft/feeds";

  xdg.configFile."newsraft/config".text = ''
    bind m exec-quiet setsid ${mpv} --terminal=no "%l" &
    bind I exec-quiet setsid ${lib.getExe openImage} "%l" &
    bind b exec ${chawan} "%l"
  '';
}
