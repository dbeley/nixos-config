{ user, inputs, system, ... }:

let
  addons = inputs.firefox-addons.packages.${system};
in
{
  programs.firefox = {
    enable = true;
    extensions = with addons; [
      augmented-steam
      cookie-autodelete
      h264ify
      multi-account-containers
      firefox-translations
      keepassxc-browser
      reddit-enhancement-suite
      reddit-comment-collapser
      return-youtube-dislikes
      steam-database
      ublock-origin
      vimium
      web-scrobbler
    ];
    profiles.${user} = {
      settings = {
        "beacon.enabled" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.openInTabClosesMenu" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.showMobileBookmarks" = false;
        "browser.compactmode.show" = true;
        "browser.contentblocking.category" = "strict";
        "browser.display.background_color" = "#666666";
        "browser.download.alwaysOpenPanel" = false;
        "browser.download.autoHideButton" = false;
        "browser.download.open_pdf_attachments_inline" = true;
        "browser.download.panel.shown" = true;
        "browser.download.useDownloadDir" = false;
        "browser.formfill.enable" = false;
        "browser.fullscreen.autohide" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.section.highlights.rows" = 4;
        "browser.newtabpage.activity-stream.topSitesRows" = 4;
        "browser.newtabpage.pinned" = "[]";
        "browser.safebrowsing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.search.context.loadInBackground" = true;
        "browser.search.region" = "FR";
        "browser.send_pings" = false;
        "browser.sessionstore.interval" = 60000;
        "browser.startup.page" = 3;
        "browser.tabs.insertAfterCurrent" = true;
        "browser.tabs.loadBookmarksInBackground" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.translation.neverForLanguages" = "fr";
        "browser.uidensity" = 1;
        "browser.urlbar.doubleClickSelectsAll" = false;
        "browser.urlbar.trimURLS" = false;
        "dom.battery.enabled" = false;
        "dom.event.clipboardevents.enabled" = false;
        "dom.event.autocomplete.formautofill" = true;
        "extensions.pocket.enabled" = false;
        "findbar.highlightAll" = true;
        "fission.autostart"  = true;
        "font.name.monospace.x-western" = "IosevkaTerm Nerd Font Mono";
        "font.name.sans-serif.x-western" = "Overpass Nerd Font";
        "font.name.serif.x-western" = "Overpass Nerd Font";
        "full-screen-api.warning.timeout" = 0;
        "general.autoScroll" = true;
        "general.smoothScroll" = false;
        "gfx.webrender.all" = true;
        "javascript.use_us_english_locale" = true;
        "layout.spellcheckDefault" = 0;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.hardwaremediakeys.enabled" = true;
        "media.navigator.mediadatadecoder_vpx_enabled" = true;
        "media.rdd-vpx.enabled" = false;
        "media.videocontrols.picture-in-picture.audio-toggle.enabled" = true;
        "media.videocontrols.picture-in-picture.keyboard-controls.enabled" = true;
        "network.IDN_show_punycode" = true;
        "network.cookie.cookieBehavior" = 5;
        "privacy.donottrackheader.enabled" = true;
        "privacy.firstparty.isolate" = true;
        "privacy.firstparty.isolate.restrict_opener_access" = true;
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = false;
        "privacy.spoof_english" = 2;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.extension" = "@testpilot-containers";
        "privacy.userContext.ui.enabled" = true;
        "signon.autofillForms" = false;
        "signon.generation.enabled" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.rememberSignons" = false;
        "ui.systemUsesDarkTheme" = 1;
      };
    };
  };
}
