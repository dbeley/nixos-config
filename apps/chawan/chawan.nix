{
  config,
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

  xdg = {
    dataFile."chawan/bookmark.md".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Nextcloud/10-19_Documents/18_Config/18.24_chawan/bookmark.md";

    configFile."chawan/config.toml".text = ''

      [buffer]
      # styling = true        # default:
      # scripting = false     # default: enable per site instead
      # cookie = false        # default: enable per site instead
      # history = true        # default:
      # meta-refresh = "ask"  # default:
      # mark-links = false    # default:
      images = true

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

    configFile."chawan/mailcap".text = ''
      image/*; swayimg %s
      video/*; mpv %s
      audio/*; mpv %s
      application/pdf; zathura %s
    '';
  };
}
