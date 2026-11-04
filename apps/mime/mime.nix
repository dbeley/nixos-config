{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ xdg-utils ];
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "${config.home.homeDirectory}";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Téléchargements";
      music = "${config.home.homeDirectory}/Musique";
      pictures = "${config.home.homeDirectory}/Images";
      publicShare = "${config.home.homeDirectory}";
      templates = "${config.home.homeDirectory}";
      videos = "${config.home.homeDirectory}/Vidéos";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/clarisworks" = [
          "calc.desktop"
          "draw.desktop"
          "writer.desktop"
        ];
        "application/csv" = [ "calc.desktop" ];
        "application/excel" = [ "calc.desktop" ];
        "application/json" = [ "org.pwmt.zathura.desktop" ];
        "application/macwriteii" = [ "writer.desktop" ];
        "application/mathml+xml" = [ "math.desktop" ];
        "application/msword" = [ "writer.desktop" ];
        "application/mxf" = [ "mpv.desktop" ];
        "application/octet-stream" = [ "mpv.desktop" ];
        "application/ogg" = [ "mpv.desktop" ];
        "application/pdf" = [
          "org.gnome.Papers.desktop"
          "org.pwmt.zathura.desktop"
        ];
        "application/pkcs12" = [ "gcr-viewer.desktop" ];
        "application/rtf" = [ "writer.desktop" ];
        "application/sdp" = [ "mpv.desktop" ];
        "application/smil+xml" = [ "mpv.desktop" ];
        "application/streamingmedia" = [ "mpv.desktop" ];
        "application/tab-separated-values" = [ "calc.desktop" ];
        "application/vnd.apple.keynote" = [ "impress.desktop" ];
        "application/vnd.apple.mpegurl" = [ "mpv.desktop" ];
        "application/vnd.apple.numbers" = [ "calc.desktop" ];
        "application/vnd.apple.pages" = [ "writer.desktop" ];
        "application/vnd.comicbook+zip" = [ "org.pwmt.zathura.desktop" ];
        "application/vnd.comicbook-rar" = [ "org.pwmt.zathura.desktop" ];
        "application/vnd.corel-draw" = [ "draw.desktop" ];
        "application/vnd.dbf" = [ "calc.desktop" ];
        "application/vnd.lotus-1-2-3" = [ "calc.desktop" ];
        "application/vnd.lotus-wordpro" = [ "writer.desktop" ];
        "application/vnd.ms-asf" = [ "mpv.desktop" ];
        "application/vnd.ms-excel" = [ "calc.desktop" ];
        "application/vnd.ms-excel.sheet.binary.macroEnabled.12" = [ "calc.desktop" ];
        "application/vnd.ms-excel.sheet.macroEnabled.12" = [ "calc.desktop" ];
        "application/vnd.ms-excel.template.macroEnabled.12" = [ "calc.desktop" ];
        "application/vnd.ms-powerpoint" = [ "impress.desktop" ];
        "application/vnd.ms-powerpoint.presentation.macroEnabled.12" = [ "impress.desktop" ];
        "application/vnd.ms-powerpoint.slideshow.macroEnabled.12" = [ "impress.desktop" ];
        "application/vnd.ms-powerpoint.template.macroEnabled.12" = [ "impress.desktop" ];
        "application/vnd.ms-publisher" = [ "draw.desktop" ];
        "application/vnd.ms-word.document.macroEnabled.12" = [ "writer.desktop" ];
        "application/vnd.ms-word.template.macroEnabled.12" = [ "writer.desktop" ];
        "application/vnd.ms-works" = [
          "calc.desktop"
          "writer.desktop"
        ];
        "application/vnd.nextcloud" = [ "com.nextcloud.desktopclient.nextcloud.desktop" ];
        "application/vnd.oasis.opendocument.base" = [ "base.desktop" ];
        "application/vnd.oasis.opendocument.chart" = [ "calc.desktop" ];
        "application/vnd.oasis.opendocument.chart-template" = [ "calc.desktop" ];
        "application/vnd.oasis.opendocument.formula" = [ "math.desktop" ];
        "application/vnd.oasis.opendocument.formula-template" = [ "math.desktop" ];
        "application/vnd.oasis.opendocument.graphics" = [ "draw.desktop" ];
        "application/vnd.oasis.opendocument.graphics-flat-xml" = [ "draw.desktop" ];
        "application/vnd.oasis.opendocument.graphics-template" = [ "draw.desktop" ];
        "application/vnd.oasis.opendocument.presentation" = [ "impress.desktop" ];
        "application/vnd.oasis.opendocument.presentation-flat-xml" = [ "impress.desktop" ];
        "application/vnd.oasis.opendocument.presentation-template" = [ "impress.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet" = [ "calc.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet-flat-xml" = [ "calc.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet-template" = [ "calc.desktop" ];
        "application/vnd.oasis.opendocument.text" = [ "writer.desktop" ];
        "application/vnd.oasis.opendocument.text-flat-xml" = [ "writer.desktop" ];
        "application/vnd.oasis.opendocument.text-master" = [ "writer.desktop" ];
        "application/vnd.oasis.opendocument.text-master-template" = [ "writer.desktop" ];
        "application/vnd.oasis.opendocument.text-template" = [ "writer.desktop" ];
        "application/vnd.oasis.opendocument.text-web" = [ "writer.desktop" ];
        "application/vnd.openofficeorg.extension" = [ "startcenter.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [
          "impress.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.presentationml.slide" = [
          "impress.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.presentationml.slideshow" = [
          "impress.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.presentationml.template" = [
          "impress.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [
          "calc.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.template" = [
          "calc.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
          "writer.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.template" = [
          "writer.desktop"
        ];
        "application/vnd.palm" = [ "writer.desktop" ];
        "application/vnd.rn-realmedia" = [ "mpv.desktop" ];
        "application/vnd.stardivision.writer-global" = [ "writer.desktop" ];
        "application/vnd.sun.xml.calc" = [ "calc.desktop" ];
        "application/vnd.sun.xml.calc.template" = [ "calc.desktop" ];
        "application/vnd.sun.xml.draw" = [ "draw.desktop" ];
        "application/vnd.sun.xml.draw.template" = [ "draw.desktop" ];
        "application/vnd.sun.xml.impress" = [ "impress.desktop" ];
        "application/vnd.sun.xml.impress.template" = [ "impress.desktop" ];
        "application/vnd.sun.xml.math" = [ "math.desktop" ];
        "application/vnd.sun.xml.writer" = [ "writer.desktop" ];
        "application/vnd.sun.xml.writer.global" = [ "writer.desktop" ];
        "application/vnd.sun.xml.writer.template" = [ "writer.desktop" ];
        "application/vnd.visio" = [ "draw.desktop" ];
        "application/vnd.wordperfect" = [ "writer.desktop" ];
        "application/x-abiword" = [ "writer.desktop" ];
        "application/x-aportisdoc" = [ "writer.desktop" ];
        "application/x-cue" = [ "mpv.desktop" ];
        "application/x-doc" = [ "writer.desktop" ];
        "application/x-dos_ms_excel" = [ "calc.desktop" ];
        "application/x-excel" = [ "calc.desktop" ];
        "application/x-extension-m4a" = [ "mpv.desktop" ];
        "application/x-extension-mp4" = [ "mpv.desktop" ];
        "application/x-extension-txt" = [ "writer.desktop" ];
        "application/x-fictionbook+xml" = [ "writer.desktop" ];
        "application/x-hwp" = [ "writer.desktop" ];
        "application/x-keepass2" = [ "org.keepassxc.KeePassXC.desktop" ];
        "application/x-matroska" = [ "mpv.desktop" ];
        "application/x-mpegurl" = [ "mpv.desktop" ];
        "application/x-ms-excel" = [ "calc.desktop" ];
        "application/x-mswrite" = [ "writer.desktop" ];
        "application/x-ogm" = [ "mpv.desktop" ];
        "application/x-ogm-audio" = [ "mpv.desktop" ];
        "application/x-ogm-video" = [ "mpv.desktop" ];
        "application/x-pagemaker" = [ "draw.desktop" ];
        "application/x-pem-file" = [ "gcr-viewer.desktop" ];
        "application/x-pem-key" = [ "gcr-viewer.desktop" ];
        "application/x-pkcs7-certificates" = [ "gcr-viewer.desktop" ];
        "application/x-quattropro" = [ "calc.desktop" ];
        "application/x-shorten" = [ "mpv.desktop" ];
        "application/x-smil" = [ "mpv.desktop" ];
        "application/x-sony-bbeb" = [ "writer.desktop" ];
        "application/x-spkac" = [ "gcr-viewer.desktop" ];
        "application/x-spkac+base64" = [ "gcr-viewer.desktop" ];
        "application/x-starcalc" = [ "calc.desktop" ];
        "application/x-stardraw" = [ "draw.desktop" ];
        "application/x-starwriter" = [ "writer.desktop" ];
        "application/x-streamingmedia" = [ "mpv.desktop" ];
        "application/x-sylk" = [ "calc.desktop" ];
        "application/x-t602" = [ "writer.desktop" ];
        "application/x-visual-studio-code-workspace" = [ "visual-studio-code.desktop" ];
        "application/x-wpg" = [ "draw.desktop" ];
        "application/x-x509-ca-cert" = [ "gcr-viewer.desktop" ];
        "application/x-x509-user-cert" = [ "gcr-viewer.desktop" ];
        "application/x-xpinstall" = [ "firefox.desktop" ];
        "application/x-zoom" = [ "Zoom.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/xhtml_xml" = [ "firefox.desktop" ];
        "audio/AMR" = [ "mpv.desktop" ];
        "audio/aac" = [ "mpv.desktop" ];
        "audio/ac3" = [ "mpv.desktop" ];
        "audio/aiff" = [ "mpv.desktop" ];
        "audio/amr-wb" = [ "mpv.desktop" ];
        "audio/dv" = [ "mpv.desktop" ];
        "audio/eac3" = [ "mpv.desktop" ];
        "audio/flac" = [ "mpv.desktop" ];
        # Canonical shared-mime-info names: the x-* variants are only aliases,
        # and xdg-mime does not resolve aliases when looking up mimeapps.
        "audio/matroska" = [ "mpv.desktop" ];
        "audio/mp1" = [ "mpv.desktop" ];
        "audio/mp2" = [ "mpv.desktop" ];
        "audio/mp4" = [ "mpv.desktop" ];
        "audio/mpeg" = [ "mpv.desktop" ];
        "audio/mpeg2" = [ "mpv.desktop" ];
        "audio/mpeg3" = [ "mpv.desktop" ];
        "audio/mpg" = [ "mpv.desktop" ];
        "audio/musepack" = [ "mpv.desktop" ];
        "audio/ogg" = [ "mpv.desktop" ];
        "audio/opus" = [ "mpv.desktop" ];
        "audio/rn-mpeg" = [ "mpv.desktop" ];
        "audio/vnd.dolby.heaac.1" = [ "mpv.desktop" ];
        "audio/vnd.dolby.heaac.2" = [ "mpv.desktop" ];
        "audio/vnd.dts" = [ "mpv.desktop" ];
        "audio/vnd.dts.hd" = [ "mpv.desktop" ];
        "audio/vnd.rn-realaudio" = [ "mpv.desktop" ];
        "audio/vnd.wave" = [ "mpv.desktop" ];
        "audio/webm" = [ "mpv.desktop" ];
        "audio/x-adpcm" = [ "mpv.desktop" ];
        "audio/x-aiff" = [ "mpv.desktop" ];
        "audio/x-ape" = [ "mpv.desktop" ];
        "audio/x-mp1" = [ "mpv.desktop" ];
        "audio/x-mpegurl" = [ "mpv.desktop" ];
        "audio/x-ms-asf" = [ "mpv.desktop" ];
        "audio/x-ms-asx" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "audio/x-ms-wma" = [ "mpv.desktop" ];
        "audio/x-musepack" = [ "mpv.desktop" ];
        "audio/x-pls" = [ "mpv.desktop" ];
        "audio/x-pn-au" = [ "mpv.desktop" ];
        "audio/x-pn-wav" = [ "mpv.desktop" ];
        "audio/x-pn-windows-pcm" = [ "mpv.desktop" ];
        "audio/x-realaudio" = [ "mpv.desktop" ];
        "audio/x-scpls" = [ "mpv.desktop" ];
        "audio/x-tta" = [ "mpv.desktop" ];
        "audio/x-vorbis+ogg" = [ "mpv.desktop" ];
        "audio/x-wavpack" = [ "mpv.desktop" ];
        "image/bmp" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/emf" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/gif" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/jpeg" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/jpg" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/png" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/svg+xml" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/tiff" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/vnd.microsoft.icon" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/vnd.zbrush.pcx" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/webp" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/wmf" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-freehand" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-png" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-portable-anymap" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-portable-bitmap" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-portable-graymap" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-portable-pixmap" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-tga" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-xbitmap" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/xpm" = [
          "swayimg.desktop"
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        # lf is not enabled on any host; yazi is part of the common home modules
        "inode/directory" = [ "yazi.desktop" ];
        "text/comma-separated-values" = [ "calc.desktop" ];
        "text/csv" = [ "calc.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "text/tab-separated-values" = [ "calc.desktop" ];
        "video/3gpp" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/3gpp2" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/dv" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/matroska" = [
          "mpv.desktop"
        ];
        "video/matroska-3d" = [
          "mpv.desktop"
        ];
        "video/mkv" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/mp2t" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/mp4" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/mpeg" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/ogg" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/quicktime" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/vnd.avi" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/vnd.mpegurl" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/vnd.rn-realvideo" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/webm" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/x-flic" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/x-flv" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/x-mpeg3" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/x-ms-afs" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/x-ms-wmv" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/x-ms-wvxvideo" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/x-ogm+ogg" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "video/x-theora+ogg" = [
          "io.github.phoneybadger.Showtime.desktop"
          "mpv.desktop"
        ];
        "x-scheme-handler/callto" = [ "Zoom.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/molotov" = [ "appimagekit-molotov.desktop" ];
        "x-scheme-handler/qute" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/steam" = [ "steam.desktop" ];
        "x-scheme-handler/steamlink" = [ "steam.desktop" ];
        "x-scheme-handler/tel" = [ "Zoom.desktop" ];
        "x-scheme-handler/vnd.libreoffice.cmis" = [ "startcenter.desktop" ];
        "x-scheme-handler/vscode" = [ "visual-studio-code-url-handler.desktop" ];
        "x-scheme-handler/zoommtg" = [ "Zoom.desktop" ];
        "x-scheme-handler/zoomphonecall" = [ "Zoom.desktop" ];
        "x-scheme-handler/zoomus" = [ "Zoom.desktop" ];
      };
    };
  };
}
