{
  lib,
  pkgs,
  ...
}:
let
  wlCopy = lib.getExe' pkgs.wl-clipboard-rs "wl-copy";
  wlPaste = lib.getExe' pkgs.wl-clipboard-rs "wl-paste";
in
{
  home.packages = with pkgs; [
    chawan
    wl-clipboard-rs
  ];

  # Chawan prefers XDG config when ~/.config/chawan/config.toml exists.
  # Its data (bookmarks, history, cookies) lives in ~/.local/share/chawan.
  xdg.configFile."chawan/config.toml".text = ''
    # Chawan configuration for the MNT Pocket Reform.
    # Defaults are vi-like; only the useful overrides are listed here.

    [start]
    visual-home = "about:chawan"
    console-buffer = true

    [buffer]
    # Keep the modern CSS layout but make scripting opt-in per site.
    styling = true
    scripting = false
    cookie = false
    history = true
    images = true
    meta-refresh = "ask"
    mark-links = false

    [search]
    wrap = true
    ignore-case = "auto"

    [encoding]
    document-charset = ["utf-8", "sjis", "euc-jp", "latin2"]
    display-charset = "auto"

    [external]
    bookmark = "$CHA_DATA_DIR/bookmark.md"
    history-file = "$CHA_DATA_DIR/history.uri"
    history-size = 500
    cookie-file = "$CHA_DATA_DIR/cookies.txt"
    download-dir = "~/Téléchargements/"
    show-download-panel = true
    editor = "kak"
    copy-cmd = "${wlCopy}"
    paste-cmd = "${wlPaste} --no-newline"
    auto-mailcap = "$CHA_DIR/mailcap"

    [network]
    max-redirect = 10
    # A53 + Wi-Fi: fewer parallel connections keep the browser responsive.
    max-net-connections = 6
    prepend-scheme = "https://"
    allow-http-from-file = false
    default-headers = {
      User-Agent = "chawan",
      Accept = "text/html, text/*;q=0.5, */*;q=0.4",
      Accept-Encoding = "gzip, deflate, br",
      Accept-Language = "fr-FR,fr;q=0.9,en;q=0.8",
      Pragma = "no-cache",
      Cache-Control = "no-cache"
    }

    [input]
    vi-numeric-prefix = true
    use-mouse = "auto"
    osc52-copy = "auto"
    osc52-primary = "auto"
    bracketed-paste = "auto"
    wheel-scroll = 5
    side-wheel-scroll = 5

    [status]
    show-cursor-position = true
    show-hover-link = true

    [display]
    color-mode = "auto"
    format-mode = "auto"
    image-mode = "auto"
    sixel-colors = "auto"
    alt-screen = "auto"
    set-title = "auto"
    highlight-marks = true
    minimum-contrast = 100
    default-background-color = "auto"
    default-foreground-color = "auto"

    [page]
    # Defaults are vi-like. C-k opens the URL bar with DuckDuckGo Lite
    # instead of the heavier default search engine.
    'C-k' = '() => pager.load("ddg:")'

    # Extra search shortcuts for the omni-bar. The built-in ddg:, br:, wk:,
    # wd: and ms: rules remain available.
    [omnirule.gh]
    match = "^gh:"
    substitute-url = '(x) => "https://github.com/search?q=" + encodeURIComponent(x.substring(x.indexOf(":") + 1))'

    [omnirule.hn]
    match = "^hn:"
    substitute-url = '(x) => "https://hn.algolia.com/?q=" + encodeURIComponent(x.substring(x.indexOf(":") + 1))'

    [omnirule.wfr]
    match = "^wfr:"
    substitute-url = '(x) => "https://fr.wikipedia.org/wiki/Special:Search?search=" + encodeURIComponent(x.substring(x.indexOf(":") + 1))'

    [omnirule.aw]
    match = "^aw:"
    substitute-url = '(x) => "https://wiki.archlinux.org/index.php?search=" + encodeURIComponent(x.substring(x.indexOf(":") + 1))'

    [omnirule.so]
    match = "^so:"
    substitute-url = '(x) => "https://stackoverflow.com/search?q=" + encodeURIComponent(x.substring(x.indexOf(":") + 1))'

    [omnirule.mdn]
    match = "^mdn:"
    substitute-url = '(x) => "https://developer.mozilla.org/en-US/search?q=" + encodeURIComponent(x.substring(x.indexOf(":") + 1))'

    # Hacker News login needs cookies; keep them in memory only.
    [siteconf.hn]
    host = 'news\.ycombinator\.com'
    cookie = true

    # Share cookies between SourceHut subdomains.
    [siteconf.sr-ht]
    host = '(.*\.)?sr\.ht'
    cookie = true
    share-cookie-jar = 'sr.ht'

    # Old Reddit is much lighter and works without JavaScript.
    [siteconf.reddit]
    host = '(www\.)?reddit\.com'
    rewrite-url = '(x) => { x.host = "old.reddit.com"; }'

    # Text-only NPR, as recommended by the Chawan documentation.
    [siteconf.npr]
    host = '(www\.)?npr\.org'
    rewrite-url = '(x) => { x.host = "text.npr.org"; const s = x.pathname.split("/"); x.pathname = s.at(s.length > 2 ? -2 : 1); }'

    # imgur serves a placeholder unless it sees a browser-ish user agent.
    [siteconf.imgur]
    host = '(i\.)?imgur\.com'
    default-headers = {
      User-Agent = "Mozilla/5.0 chawan",
      Accept = "*/*",
      Accept-Encoding = "gzip, deflate",
      Accept-Language = "en;q=1.0",
      Pragma = "no-cache",
      Cache-Control = "no-cache"
    }
  '';

  # Chawan hands non-HTML resources to mailcap. Keep the viewers that are
  # already part of the workstation profile.
  xdg.configFile."chawan/mailcap".text = ''
    image/*; swayimg %s
    video/*; mpv %s
    audio/*; mpv %s
    application/pdf; zathura %s
  '';
}
