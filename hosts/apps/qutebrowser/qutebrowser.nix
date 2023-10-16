{
  programs.qutebrowser = {
    enable = true;
    settings = {
      url.default_page = "https://start.duckduckgo.com";
      content = {
        headers.do_not_track = true;
      };
      editor = {command = ["alacritty" "-e" "nvim" "{}"];};
      downloads = {
        position = "bottom";
        location.directory = "~/Téléchargements";
      };
      tabs = {
        show = "multiple";
        position = "bottom";
      };
    };
    searchEngines = {
      "DEFAULT" = "https://start.duckduckgo.com/?q={}";
      "s" = "https://www.startpage.com/do/search?query={}";
      "sp" = "https://www.startpage.com/do/search?query={}";
      "g" = "https://www.google.fr/search?q={}";
      "d" = "https://start.duckduckgo.com/?q={}";
      "di" = "https://start.duckduckgo.com/?ia=images&iax=images&q={}";
      "qw" = "https://qwant.com/?q={}&t=web";
      "qwi" = "https://qwant.com/?q={}&t=images";
      "gi" = "https://www.google.fr/search?q={}&tbm=isch";
      "lfm" = "https://www.last.fm/fr/search?q={}";
      "lfmd" = "https://www.last.fm/fr/music/{}";
      "rym" = "https://rateyourmusic.com/search?searchtype=a&searchterm={}";
      "rymd" = "https://rateyourmusic.com/artist/{}";
      "scr" = "https://www.senscritique.com/search?query={}";
      "map" = "https://www.google.fr/maps/?q={}";
      "eba" = "https://www.ebay.fr/sch/i.html?_nkw={}";
      "twi" = "https://twitter.com/search?q={}";
      "yt" = "https://youtube.com/results?search_query={}";
      "rarbg" = "https://rarbg.to/torrents.php?search={}";
      "aur" = "https://aur.archlinux.org/packages/?K={}";
      "arch" = "https://www.archlinux.org/packages/?q={}";
      "gplay" = "https://play.google.com/store/search?q={}";
      "ali" = "https://fr.aliexpress.com/wholesale?SearchText={}";
      "wiki" = "https://fr.wikipedia.org/w/index.php?search={}";
      "ldlc" = "https://www.ldlc.com/navigation/{}";
      "ama" = "https://www.amazon.fr/s?k={}";
      "wikien" = "https://en.wikipedia.org/w/index.php?search={}";
      "git" = "https://github.com/search?q={}";
      "rut" = "https://rutracker.org/forum/tracker.php?nm={}";
      "steam" = "https://store.steampowered.com/search/?term={}";
      "deal" = "https://www.dealabs.com/search?q={}";
      "protondb" = "https://www.protondb.com/search?q={}";
      "archwikifr" = "https://wiki.archlinux.fr/index.php?search={}";
      "archwiki" = "https://wiki.archlinux.org/index.php?search={}";
      "discogs" = "https://www.discogs.com/search/?q={}&type=all";
      "musicbrainz" = "https://musicbrainz.org/search?query={}&type=artist&method=indexed";
      "leboncoin" = "https://www.leboncoin.fr/recherche/?text={}";
      "userbenchmark" = "https://www.userbenchmark.com/Search?searchTerm={}";
      "idealo" = "https://www.idealo.fr/prechcat.html?q={}";
      "gsmarena" = "https://www.gsmarena.com/res.php3?sSearch={}";
      "xda" = "https://forum.xda-developers.com/search/?query={}";
      "reddit" = "https://www.reddit.com/search?q={}&sort=relevance&t=all";
      "subreddit" = "https://www.reddit.com/r/{}";
      "fdroid" = "https://search.f-droid.org/?q={}";
      "ug" = "https://www.ultimate-guitar.com/search.php?search_type=title&value={}";
      "trend" = "https://trends.google.fr/trends/explore?q={}";
      "stack" = "https://stackoverflow.com/search?q={}";
      "osm" = "https://www.openstreetmap.org/search?query={}";
      "goodreads" = "https://www.goodreads.com/search?q={}";
      "firefoxadd" = "https://addons.mozilla.org/fr/firefox/search/?q={}";
      "thomann" = "https://www.thomann.de/fr/search_dir.html?sw={}";
      "pypi" = "https://pypi.org/search/?q={}";
      "openrepos" = "https://openrepos.net/search/node/{}";
      "rymv" = "https://rateyourmusic.com/search?searchtype=F&searchterm={}";
      "unsplash" = "https://unsplash.com/search/photos/{}";
      "gitlab" = "https://gitlab.com/search?search={}";
      "imdb" = "https://www.imdb.com/find?ref_=nv_sr_fn&q={}&s=all";
      "nixosp" = "https://search.nixos.org/packages?from=0&size=50&sort=relevance&type=packages&query={}";
    };
  };
}
