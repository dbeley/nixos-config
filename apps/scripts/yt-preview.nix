{
  chafa,
  coreutils,
  curl,
  name,
  cacheDir,
  writeShellApplication,
}:
writeShellApplication {
  inherit name;
  runtimeInputs = [
    chafa
    coreutils
    curl
  ];
  text = ''
    id=$(printf '%s' "''${1:-}" | tr -cd 'A-Za-z0-9_-')
    [ -n "$id" ] || exit 0

    cache="''${XDG_CACHE_HOME:-$HOME/.cache}/${cacheDir}"
    mkdir -p "$cache"
    img="$cache/$id.jpg"

    if [ ! -s "$img" ]; then
      curl -fsSL --max-time 10 \
        "https://i.ytimg.com/vi/$id/mqdefault.jpg" -o "$img" || exit 0
    fi

    exec chafa --size "''${FZF_PREVIEW_COLUMNS:-60}x''${FZF_PREVIEW_LINES:-20}" "$img"
  '';
}
