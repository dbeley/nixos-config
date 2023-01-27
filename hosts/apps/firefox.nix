{ user, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.${user} = {
      settings = {
        "browser.bookmarks.openInTabClosesMenu" = false;
        "browser.compactmode.show" = true;
        "browser.contentblocking.category" = "strict";
        "browser.display.background_color" = "#666666";
        "browser.download.useDownloadDir" = false;
        "browser.formfill.enable" = false;
        "browser.fullscreen.autohide" = false;
        "browser.pocket.enabled" = false;
        "browser.search.context.loadInBackground" = true;
        "browser.sessionstore.interval" = 60000;
        "browser.tabs.insertAfterCurrent" = true;
        "browser.tabs.loadBookmarksInBackground" = true;
        "browser.urlbar.doubleClickSelectsAll" = false;
        "browser.urlbar.trimURLS" = false;
        "dom.event.clipboardevents.enabled" = false;
        "extensions.pocket.enabled" = false;
        "findbar.highlightAll" = true;
        "fission.autostart"  = true;
        "full-screen-api.warning.timeout" = 0;
        "general.autoScroll" = true;
        "general.smoothScroll" = false;
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.hardwaremediakeys.enabled" = true;
        "media.navigator.mediadatadecoder_vpx_enabled" = true;
        "media.rdd-vpx.enabled" = false;
        "media.videocontrols.picture-in-picture.audio-toggle.enabled" = true;
        "media.videocontrols.picture-in-picture.keyboard-controls.enabled" = true;
        "network.IDN_show_punycode" = true;
        "network.cookie.cookieBehavior" = 5;
        "privacy.firstparty.isolate" = true;
        "privacy.firstparty.isolate.restrict_opener_access" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = false;
        "signon.rememberSignons" = false;
        "ui.systemUsesDarkTheme" = 1;
        "browser.download.alwaysOpenPanel" = false;
        "browser.download.open_pdf_attachments_inline" = true;
      };
    };
  };
}
