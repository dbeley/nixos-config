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

  xdg.configFile."chawan/config.toml".text = ''
    # [start]
    # visual-home = "about:chawan" # default:
    # console-buffer = true        # default:

    [buffer]
    # styling = true        # default:
    # scripting = false     # default: enable per site instead
    # cookie = false        # default: enable per site instead
    # history = true        # default:
    # meta-refresh = "ask"  # default:
    # mark-links = false    # default:
    images = true

    # [search]
    # wrap = true           # default:
    # ignore-case = "auto"  # default:

    # [encoding]
    # document-charset = ["utf-8", "sjis", "euc-jp", "latin2"] # default:
    # display-charset = "auto" # default:

    [external]
    # bookmark = "$CHA_DATA_DIR/bookmark.md"     # default:
    # history-file = "$CHA_DATA_DIR/history.uri" # default:
    # cookie-file = "$CHA_DATA_DIR/cookies.txt"  # default:
    # show-download-panel = true                 # default:
    # auto-mailcap = "$CHA_DIR/mailcap"          # default:
    history-size = 500
    download-dir = "~/Téléchargements/"
    editor = "kak"
    copy-cmd = "${wlCopy}"
    paste-cmd = "${wlPaste} --no-newline"

    [network]
    # max-redirect = 10            # default:
    # prepend-scheme = "https://"  # default:
    # allow-http-from-file = false # default:
    max-net-connections = 6
    [network.default-headers]
    Accept-Language = "fr-FR,fr;q=0.9,en;q=0.8"

    # [input]
    # vi-numeric-prefix = true   # default:
    # use-mouse = "auto"         # default:
    # osc52-copy = "auto"        # default:
    # osc52-primary = "auto"     # default:
    # bracketed-paste = "auto"   # default:
    # wheel-scroll = 5           # default:
    # side-wheel-scroll = 5      # default:

    # [status]
    # show-cursor-position = true # default:
    # show-hover-link = true      # default:

    # [display]
    # color-mode = "auto"                # default:
    # format-mode = "auto"               # default:
    # image-mode = "auto"                # default:
    # sixel-colors = "auto"              # default:
    # alt-screen = "auto"                # default:
    # set-title = "auto"                 # default:
    # highlight-marks = true             # default:
    # minimum-contrast = 100             # default:
    # default-background-color = "auto"  # default:
    # default-foreground-color = "auto"  # default:

    [page]
    # Default C-k is webSearch (Brave). Use DuckDuckGo Lite instead.
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

  xdg.configFile."chawan/mailcap".text = ''
    image/*; swayimg %s
    video/*; mpv %s
    audio/*; mpv %s
    application/pdf; zathura %s
  '';
}
