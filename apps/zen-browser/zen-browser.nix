{
  config,
  inputs,
  pkgs,
  user,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.twilight ];
  programs.zen-browser = {
    enable = true;
    configPath = "${config.xdg.configHome}/zen";
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
    profiles.${user} = {
      settings = {
        # ── Zen-specific ──
        "zen.widget.linux.transparency" = true;
        "zen.workspaces.continue-where-left-off" = true;
        "zen.view.compact.hide-tabbar" = false;
        "zen.urlbar.behavior" = "float";
        "zen.welcome-screen.seen" = true;
        "zen.workspaces.separate-essentials" = false;
        "zen.theme.gradient.show-custom-colors" = true;

        # ── Privacy & security ──
        "beacon.enabled" = false;
        "browser.contentblocking.category" = "strict";
        "browser.dataFeatureRecommendations.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.safebrowsing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.send_pings" = false;
        "browser.formfill.enable" = false;
        "dom.battery.enabled" = false;
        "dom.event.clipboardevents.enabled" = false;
        "dom.security.sanitizer.enabled" = true;
        "network.IDN_show_punycode" = true;
        "network.cookie.cookieBehavior" = 5;
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
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.extension" = "@testpilot-containers";
        "privacy.userContext.ui.enabled" = true;
        "signon.autofillForms" = false;
        "signon.generation.enabled" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.rememberSignons" = false;
        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = true;
        "security.pki.crlite_mode" = 2;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.ssl.enable_ocsp_must_staple" = true;
        "security.ssl.enable_ocsp_stapling" = true;
        "security.ssl.require_safe_negotiation" = true;

        # ── Theme & transparency ──
        "browser.theme.content-theme" = 2;
        "browser.theme.toolbar-theme" = 2;
        "layout.css.prefers-color-scheme.content-override" = 2;
        "ui.systemUsesDarkTheme" = 1;
        "browser.uidensity" = 1;
        "browser.tabs.allow_transparent_browser" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "widget.transparent-windows" = true;
        "widget.wayland.opaque-region.enabled" = false;
        "browser.toolbars.bookmarks.visibility" = "never";

        # ── Tabs & windows ──
        "browser.tabs.insertAfterCurrent" = true;
        "browser.tabs.loadBookmarksInBackground" = true;
        "browser.fullscreen.autohide" = false;
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.warning.delay" = -1;
        "full-screen-api.warning.timeout" = 0;

        # ── Downloads ──
        "browser.download.alwaysOpenPanel" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.download.autoHideButton" = false;
        "browser.download.manager.addToRecentDocs" = false;
        "browser.download.open_pdf_attachments_inline" = true;
        "browser.download.panel.shown" = true;
        "browser.download.useDownloadDir" = false;

        # ── URL bar & search ──
        "browser.urlbar.doubleClickSelectsAll" = false;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.trimURLS" = false;
        "browser.urlbar.unitConversion.enabled" = true;
        "browser.search.context.loadInBackground" = true;
        "browser.search.region" = "FR";

        # ── Session & startup ──
        "browser.sessionstore.interval" = 600000;
        "browser.startup.page" = 3;
        "browser.shell.checkDefaultBrowser" = false;

        # ── Extensions ──
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.webcompat-reporter.enabled" = false;
        "xpinstall.signatures.required" = false;
        "xpinstall.whitelist.required" = false;
        "identity.fxaccounts.enabled" = true;

        # ── Media & hardware ──
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.hardwaremediakeys.enabled" = true;
        "media.navigator.mediadatadecoder_vpx_enabled" = true;
        "media.rdd-vpx.enabled" = false;
        "media.videocontrols.picture-in-picture.audio-toggle.enabled" = true;
        "media.videocontrols.picture-in-picture.keyboard-controls.enabled" = true;

        # ── Performance ──
        "nglayout.initialpaint.delay" = 0;
        "nglayout.initialpaint.delay_in_oopif" = 0;
        "network.dnsCacheExpiration" = 3600;
        "gfx.webrender.layer-compositor" = true;

        # ── Scrolling & mouse ──
        "apz.overscroll.enabled" = true;
        "general.autoScroll" = true;
        "general.smoothScroll" = false;
        "mousewheel.default.delta_multiplier_y" = 275;

        # ── Miscellaneous ──
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.openInTabClosesMenu" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.showMobileBookmarks" = false;
        "browser.menu.showViewImageInfo" = true;
        "browser.translations.neverTranslateLanguages" = "fr";
        "intl.locale.requested" = "fr";
        "intl.accept_languages" = "fr,fr-FR,en-US,en";
        "findbar.highlightAll" = true;
        "javascript.use_us_english_locale" = true;
        "layout.css.grid-template-masonry-value.enabled" = true;
        "layout.spellcheckDefault" = 0;
        "pdfjs.enableAltText" = false;
        "pdfjs.enableAltTextForEnglish" = false;
        "pdfjs.enableAltTextModelDownload" = false;
        "webgl.disabled" = false;
      };
      search = {
        force = true;
        default = "ddg";
        order = [ "ddg" ];
      };
      containersForce = true;
      containers = {
        Personnel = {
          color = "toolbar";
          icon = "circle";
          id = 1;
        };
        Local = {
          color = "blue";
          icon = "circle";
          id = 2;
        };
        Presse = {
          color = "turquoise";
          icon = "tree";
          id = 3;
        };
        Shopping = {
          color = "purple";
          icon = "food";
          id = 4;
        };
        Bancaire = {
          color = "orange";
          icon = "dollar";
          id = 5;
        };
        "Jeux vidéo" = {
          color = "blue";
          icon = "vacation";
          id = 6;
        };
        TikTok = {
          icon = "cart";
          color = "orange";
          id = 7;
        };
        Microsoft = {
          icon = "fence";
          color = "blue";
          id = 8;
        };
        LinkedIn = {
          icon = "briefcase";
          color = "turquoise";
          id = 9;
        };
        Facebook = {
          icon = "fingerprint";
          color = "blue";
          id = 10;
        };
        Instagram = {
          icon = "pet";
          color = "turquoise";
          id = 11;
        };
        Google = {
          icon = "chill";
          color = "red";
          id = 12;
        };
        Gmail = {
          icon = "fruit";
          color = "red";
          id = 13;
        };
        YouTube = {
          icon = "vacation";
          color = "red";
          id = 14;
        };
        "YouTube - Informatique" = {
          color = "blue";
          icon = "fingerprint";
          id = 15;
        };
        "YouTube - Musique" = {
          color = "turquoise";
          icon = "cart";
          id = 16;
        };
        "YouTube - Humour" = {
          color = "green";
          icon = "gift";
          id = 17;
        };
        "YouTube - Jeux Vidéo" = {
          color = "red";
          icon = "fruit";
          id = 18;
        };
        "YouTube - Politique" = {
          color = "pink";
          icon = "pet";
          id = 19;
        };
        "YouTube - Sport" = {
          color = "orange";
          icon = "tree";
          id = 20;
        };
        "YouTube - Poubelle" = {
          color = "yellow";
          icon = "fence";
          id = 21;
        };
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
          refined-github
          return-youtube-dislikes
          # sidebery
          sponsorblock
          steam-database
          transparent-zen
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
      mods = [
        "ad97bb70-0066-4e42-9b5f-173a5e42c6fc" # SuperPins
        "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
      ];
    };
  };
}
