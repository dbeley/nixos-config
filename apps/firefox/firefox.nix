{
  pkgs,
  user,
  ...
}:
{
  programs.firefox = {
    enable = true;
    policies = {
      # DisableAccounts = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      ShowHomeButton = true;
      Containers = {
        # icon can be fingerprint, briefcase, dollar, cart, vacation, gift, food,
        # fruit, pet, tree, chill, circle, fence
        # color can be blue, turquoise, green, yellow, orange, red, pink,
        # purple, toolbar
        "Default" = [
          {
            "name" = "Personnel";
            "icon" = "circle";
            "color" = "toolbar";
          }
          {
            "name" = "Local";
            "icon" = "circle";
            "color" = "blue";
          }
          {
            "name" = "Presse";
            "icon" = "tree";
            "color" = "turquoise";
          }
          {
            "name" = "Shopping";
            "icon" = "food";
            "color" = "purple";
          }
          {
            "name" = "Bancaire";
            "icon" = "dollar";
            "color" = "orange";
          }
          {
            "name" = "Jeux vidéo";
            "icon" = "vacation";
            "color" = "blue";
          }
          {
            "name" = "Instagram";
            "icon" = "chill";
            "color" = "turquoise";
          }
          {
            "name" = "TikTok";
            "icon" = "cart";
            "color" = "orange";
          }
          {
            "name" = "Microsoft";
            "icon" = "fence";
            "color" = "blue";
          }
          {
            "name" = "LinkedIn";
            "icon" = "briefcase";
            "color" = "turquoise";
          }
          {
            "name" = "Google";
            "icon" = "chill";
            "color" = "red";
          }
          {
            "name" = "Gmail";
            "icon" = "fruit";
            "color" = "red";
          }
          {
            "name" = "YouTube";
            "icon" = "vacation";
            "color" = "red";
          }
          {
            "name" = "YouTube - Informatique";
            "icon" = "fingerprint";
            "color" = "blue";
          }
          {
            "name" = "YouTube - Musique";
            "icon" = "cart";
            "color" = "turquoise";
          }
          {
            "name" = "YouTube - Humour";
            "icon" = "gift";
            "color" = "green";
          }
          {
            "name" = "YouTube - Jeux Vidéo";
            "icon" = "fruit";
            "color" = "red";
          }
          {
            "name" = "YouTube - Politique";
            "icon" = "pet";
            "color" = "pink";
          }
          {
            "name" = "YouTube - Sport";
            "icon" = "tree";
            "color" = "orange";
          }
          {
            "name" = "YouTube - Poubelle";
            "icon" = "fence";
            "color" = "yellow";
          }
        ];
      };
    };
    profiles.${user} = {
      settings = {
        "accessibility.force_disabled" = 1;
        "apz.overscroll.enabled" = true;
        "beacon.enabled" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.openInTabClosesMenu" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.showMobileBookmarks" = false;
        "browser.compactmode.show" = true;
        "browser.contentblocking.category" = "strict";
        "browser.display.background_color" = "#666666";
        "browser.download.alwaysOpenPanel" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.download.autoHideButton" = false;
        "browser.download.manager.addToRecentDocs" = false;
        "browser.download.open_pdf_attachments_inline" = true;
        "browser.download.panel.shown" = true;
        "browser.download.useDownloadDir" = false;
        "browser.download.viewableInternally.typeWasRegistered.svg" = true;
        "browser.download.viewableInternally.typeWasRegistered.webp" = true;
        "browser.download.viewableInternally.typeWasRegistered.xml" = true;
        "browser.formfill.enable" = false;
        "browser.fullscreen.autohide" = false;
        "browser.menu.showViewImageInfo" = true;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = true;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
        "browser.newtabpage.activity-stream.section.highlights.rows" = 4;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.topSitesRows" = 4;
        "browser.newtabpage.pinned" = "[]";
        "browser.preferences.moreFromMozilla" = false;
        "browser.safebrowsing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.search.context.loadInBackground" = true;
        "browser.search.defaultenginename" = "ddg";
        "browser.search.order.1" = "ddg";
        "browser.search.region" = "FR";
        "browser.send_pings" = false;
        "browser.sessionstore.interval" = 60000;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.page" = 3;
        "browser.tabs.firefox-view" = false;
        "browser.tabs.firefox-view-next" = false;
        "browser.tabs.insertAfterCurrent" = true;
        "browser.tabs.loadBookmarksInBackground" = true;
        "browser.tabs.tabmanager.enabled" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.translation.neverForLanguages" = "fr";
        "browser.uidensity" = 1;
        "browser.urlbar.doubleClickSelectsAll" = false;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.trimURLS" = false;
        "browser.urlbar.unitConversion.enabled" = true;
        "dom.battery.enabled" = false;
        "dom.enable_web_task_scheduling" = true;
        "dom.event.clipboardevents.enabled" = false;
        "dom.security.sanitizer.enabled" = true;
        # "extensions.formautofill.addresses.enabled" = false;
        # "extensions.formautofill.available" = "off";
        # "extensions.formautofill.creditCards.enabled" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        # "extensions.pocket.enabled" = false;
        "findbar.highlightAll" = true;
        "fission.autostart" = true;
        "font.default.x-western" = "serif";
        # "font.name.monospace.x-western" = "IosevkaTerm Nerd Font Mono";
        "font.name.sans-serif.x-western" = "Overpass";
        "font.name.serif.x-western" = "EB Garamond";
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.warning.delay" = -1;
        "full-screen-api.warning.timeout" = 0;
        "general.autoScroll" = true;
        "general.smoothScroll" = false;
        "gfx.webrender.all" = true;
        "identity.fxaccounts.enabled" = true;
        "javascript.use_us_english_locale" = true;
        "layout.css.grid-template-masonry-value.enabled" = true;
        "layout.css.has-selector.enabled" = true;
        "layout.spellcheckDefault" = 0;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.hardwaremediakeys.enabled" = true;
        "media.navigator.mediadatadecoder_vpx_enabled" = true;
        "media.rdd-vpx.enabled" = false;
        "media.videocontrols.picture-in-picture.audio-toggle.enabled" = true;
        "media.videocontrols.picture-in-picture.keyboard-controls.enabled" = true;
        "mousewheel.default.delta_multiplier_y" = 275;
        "network.IDN_show_punycode" = true;
        "network.cookie.cookieBehavior" = 5;
        "network.dns.max_high_priority_threads" = 8;
        "network.dnsCacheExpiration" = 3600;
        "network.http.pacing.requests.enabled" = false;
        "network.ssl_tokens_cache_capacity" = 10240;
        "nglayout.initialpaint.delay" = 0;
        "nglayout.initialpaint.delay_in_oopif" = 0;
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.offlineApps" = false;
        "privacy.clearOnShutdown.sessions" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.firstparty.isolate" = true;
        "privacy.firstparty.isolate.restrict_opener_access" = true;
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = false;
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.spoof_english" = 2;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.extension" = "@testpilot-containers";
        "privacy.userContext.ui.enabled" = true;
        "privacy.window.maxInnerHeigth" = 900;
        "privacy.window.maxInnerWidth" = 1600;
        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = true;
        "security.pki.crlite_mode" = 2;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.ssl.enable_ocsp_must_staple" = true;
        "security.ssl.enable_ocsp_stapling" = true;
        "security.ssl.require_safe_negotiation" = true;
        "signon.autofillForms" = false;
        "signon.generation.enabled" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.rememberSignons" = false;
        "ui.systemUsesDarkTheme" = 1;
        "webgl.disabled" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 0;
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        augmented-steam
        # darkreader
        hover-zoom-plus
        keepassxc-browser
        multi-account-containers
        # protondb-for-steam
        # reddit-comment-collapser
        reddit-enhancement-suite
        return-youtube-dislikes
        # sidebery
        sponsorblock
        # steam-database
        ublock-origin
        vimium
        violentmonkey
        web-scrobbler
      ];
      search = {
        force = true;
        default = "ddg";
        order = [ "ddg" ];
      };
    };
  };
}
