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
            "name" = "Facebook";
            "icon" = "fingerprint";
            "color" = "blue";
          }
          {
            "name" = "Instagram";
            "icon" = "pet";
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
        "apz.overscroll.enabled" = true;
        "beacon.enabled" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.openInTabClosesMenu" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.showMobileBookmarks" = false;
        "browser.compactmode.show" = true;
        "browser.contentblocking.category" = "strict";
        "browser.dataFeatureRecommendations.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.display.background_color" = "#666666";
        "browser.download.alwaysOpenPanel" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.download.autoHideButton" = false;
        "browser.download.manager.addToRecentDocs" = false;
        "browser.download.open_pdf_attachments_inline" = true;
        "browser.download.panel.shown" = true;
        "browser.download.useDownloadDir" = false;
        "browser.formfill.enable" = false;
        "browser.fullscreen.autohide" = false;
        "browser.menu.showViewImageInfo" = true;
        "browser.ml.chat.menu" = false;
        "browser.ml.chat.enabled" = false;
        "browser.ml.enable" = false;
        "browser.ml.linkPreview.optin" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.ml.linkPreview.longPress" = false;
        "browser.ml.pageAssist.enabled" = false;
        "browser.ml.smartAssist.enabled" = false;
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
        "browser.search.region" = "FR";
        "browser.send_pings" = false;
        "browser.sessionstore.interval" = 600000;
        "browser.sessionstore.resume_from_crash" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.page" = 3;
        "browser.tabs.firefox-view" = false;
        "browser.tabs.firefox-view-next" = false;
        "browser.tabs.groups.smart.enabled" = false;
        "browser.tabs.groups.smart.userEnabled" = false;
        "browser.tabs.insertAfterCurrent" = true;
        "browser.tabs.loadBookmarksInBackground" = true;
        "browser.tabs.splitView.enabled" = true;
        "browser.tabs.tabmanager.enabled" = false;
        "browser.theme.content-theme" = 2;
        "browser.theme.toolbar-theme" = 2;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.translations.neverTranslateLanguages" = "fr";
        "browser.uidensity" = 1;
        "browser.urlbar.doubleClickSelectsAll" = false;
        "browser.urlbar.quicksuggest.mlEnabled" = false;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.trimURLS" = false;
        "browser.urlbar.unitConversion.enabled" = true;
        "layout.css.prefers-color-scheme.content-override" = 2;
        "dom.battery.enabled" = false;
        "dom.event.clipboardevents.enabled" = false;
        "dom.security.sanitizer.enabled" = true;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.ml.enabled" = false;
        "extensions.webcompat-reporter.enabled" = false;
        "findbar.highlightAll" = true;
        "font.default.x-western" = "serif";
        "font.name.sans-serif.x-western" = "Overpass";
        "font.name.serif.x-western" = "EB Garamond";
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.warning.delay" = -1;
        "full-screen-api.warning.timeout" = 0;
        "general.autoScroll" = true;
        "general.smoothScroll" = false;
        "identity.fxaccounts.enabled" = true;
        "javascript.use_us_english_locale" = true;
        "layout.css.grid-template-masonry-value.enabled" = true;
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
        "network.dnsCacheExpiration" = 3600;
        "nglayout.initialpaint.delay" = 0;
        "nglayout.initialpaint.delay_in_oopif" = 0;
        "pdfjs.enableAltText" = false;
        "pdfjs.enableAltTextForEnglish" = false;
        "pdfjs.enableAltTextModelDownload" = false;
        "places.semanticHistory.featureGate" = false;
        "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
        "privacy.clearOnShutdown_v2.cache" = true;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "privacy.clearOnShutdown_v2.formdata" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC";
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "privacy.resistFingerprinting" = false;
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.extension" = "@testpilot-containers";
        "privacy.userContext.ui.enabled" = true;
        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = true;
        "security.pki.crlite_mode" = 2;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.ssl.enable_ocsp_must_staple" = true;
        "security.ssl.enable_ocsp_stapling" = true;
        "security.ssl.require_safe_negotiation" = true;
        "sidebar.notification.badge.aichat" = false;
        "signon.autofillForms" = false;
        "signon.generation.enabled" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.rememberSignons" = false;
        "ui.systemUsesDarkTheme" = 1;
        "webgl.disabled" = false;
        "xpinstall.signatures.required" = false;
        "xpinstall.whitelist.required" = false;
      };
      extensions.packages =
        (with pkgs.nur.repos.rycee.firefox-addons; [
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
          steam-database
          ublock-origin
          vimium
          violentmonkey
          web-scrobbler
        ])
        ++ [
          (pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon (
            let
              version = "0.1.3";
            in
            {
              pname = "cachearena";
              inherit version;
              addonId = "cachearena@dbeley.ovh";
              url = "https://github.com/dbeley/cachearena/releases/download/v${version}/cachearena-${version}.xpi";
              sha256 = "sha256-QDli3Q2E2yHrv3DG+12oNkL7+RaoISGd7AUR9EfdMgo=";
              meta = { };
            }
          ))
          (pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon (
            let
              version = "0.2.4";
            in
            {
              pname = "comping";
              inherit version;
              addonId = "comping@dbeley.ovh";
              url = "https://github.com/dbeley/comping/releases/download/v${version}/comping-${version}.xpi";
              sha256 = "sha256-lrFm6iydkIBD2s5YIFmmaEySGiFfsBSH4uGA1ukAVJo=";
              meta = { };
            }
          ))
        ];
      search = {
        force = true;
        default = "ddg";
        order = [ "ddg" ];
      };
    };
  };
}
