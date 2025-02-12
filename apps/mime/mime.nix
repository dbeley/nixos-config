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
          "libreoffice-calc.desktop"
          "libreoffice-draw.desktop"
          "libreoffice-writer.desktop"
        ];
        "application/csv" = [ "libreoffice-calc.desktop" ];
        "application/excel" = [ "libreoffice-calc.desktop" ];
        "application/json" = [ "org.pwmt.zathura.desktop" ];
        "application/macwriteii" = [ "libreoffice-writer.desktop" ];
        "application/mathml+xml" = [ "libreoffice-math.desktop" ];
        "application/msexcel" = [ "libreoffice-calc.desktop" ];
        "application/mspowerpoint" = [ "libreoffice-impress.desktop" ];
        "application/msword" = [ "libreoffice-writer.desktop" ];
        "application/mxf" = [ "mpv.desktop" ];
        "application/ogg" = [ "mpv.desktop" ];
        "application/pdf" = [
          "org.pwmt.zathura.desktop"
          "org.gnome.Papers.desktop"
        ];
        "application/vnd.comicbook+zip" = [ "org.pwmt.zathura.desktop" ];
        "application/vnd.comicbook-rar" = [ "org.pwmt.zathura.desktop" ];
        "application/rdf+xml" = [ "editor.desktop" ];
        "application/rss+xml" = [ "editor.desktop" ];
        "application/rtf" = [ "libreoffice-writer.desktop" ];
        "application/sdp" = [ "mpv.desktop" ];
        "application/smil" = [ "mpv.desktop" ];
        "application/streamingmedia" = [ "mpv.desktop" ];
        "application/tab-separated-values" = [ "libreoffice-calc.desktop" ];
        "application/vnd.apple.mpegurl" = [ "mpv.desktop" ];
        "application/vnd.corel-draw" = [ "libreoffice-draw.desktop" ];
        "application/vnd.lotus-1-2-3" = [ "libreoffice-calc.desktop" ];
        "application/vnd.lotus-wordpro" = [ "libreoffice-writer.desktop" ];
        "application/vnd.ms-asf" = [ "mpv.desktop" ];
        "application/vnd.ms-excel.sheet.binary.macroEnabled.12" = [ "libreoffice-calc.desktop" ];
        "application/vnd.ms-excel.sheet.macroEnabled.12" = [ "libreoffice-calc.desktop" ];
        "application/vnd.ms-excel.template.macroEnabled.12" = [ "libreoffice-calc.desktop" ];
        "application/vnd.ms-excel" = [ "libreoffice-calc.desktop" ];
        "application/vnd.ms-powerpoint.presentation.macroEnabled.12" = [ "libreoffice-impress.desktop" ];
        "application/vnd.ms-powerpoint.slideshow.macroEnabled.12" = [ "libreoffice-impress.desktop" ];
        "application/vnd.ms-powerpoint.template.macroEnabled.12" = [ "libreoffice-impress.desktop" ];
        "application/vnd.ms-powerpoint" = [ "libreoffice-impress.desktop" ];
        "application/vnd.ms-publisher" = [ "libreoffice-draw.desktop" ];
        "application/vnd.ms-word.document.macroEnabled.12" = [ "libreoffice-writer.desktop" ];
        "application/vnd.ms-word.template.macroEnabled.12" = [ "libreoffice-writer.desktop" ];
        "application/vnd.ms-word" = [ "libreoffice-writer.desktop" ];
        "application/vnd.ms-works" = [ "libreoffice-calc.desktoplibreoffice-writer.desktop;" ];
        "application/vnd.nextcloud" = [ "com.nextcloud.desktopclient.nextcloud.desktop" ];
        "application/vnd.oasis.opendocument.chart-template" = [ "libreoffice-calc.desktop" ];
        "application/vnd.oasis.opendocument.chart" = [ "libreoffice-calc.desktop" ];
        "application/vnd.oasis.opendocument.database" = [ "libreoffice-base.desktop" ];
        "application/vnd.oasis.opendocument.formula-template" = [ "libreoffice-math.desktop" ];
        "application/vnd.oasis.opendocument.formula" = [ "libreoffice-math.desktop" ];
        "application/vnd.oasis.opendocument.graphics-flat-xml" = [ "libreoffice-draw.desktop" ];
        "application/vnd.oasis.opendocument.graphics-template" = [ "libreoffice-draw.desktop" ];
        "application/vnd.oasis.opendocument.graphics" = [ "libreoffice-draw.desktop" ];
        "application/vnd.oasis.opendocument.presentation-flat-xml" = [ "libreoffice-impress.desktop" ];
        "application/vnd.oasis.opendocument.presentation-template" = [ "libreoffice-impress.desktop" ];
        "application/vnd.oasis.opendocument.presentation" = [ "libreoffice-impress.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet-flat-xml" = [ "libreoffice-calc.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet-template" = [ "libreoffice-calc.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet" = [ "libreoffice-calc.desktop" ];
        "application/vnd.oasis.opendocument.text-flat-xml" = [ "libreoffice-writer.desktop" ];
        "application/vnd.oasis.opendocument.text-master-template" = [ "libreoffice-writer.desktop" ];
        "application/vnd.oasis.opendocument.text-master" = [ "libreoffice-writer.desktop" ];
        "application/vnd.oasis.opendocument.text-template" = [ "libreoffice-writer.desktop" ];
        "application/vnd.oasis.opendocument.text-web" = [ "libreoffice-writer.desktop" ];
        "application/vnd.oasis.opendocument.text" = [ "libreoffice-writer.desktop" ];
        "application/vnd.openofficeorg.extension" = [ "libreoffice-startcenter.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [
          "libreoffice-impress.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.presentationml.slide" = [
          "libreoffice-impress.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.presentationml.slideshow" = [
          "libreoffice-impress.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.presentationml.template" = [
          "libreoffice-impress.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [
          "libreoffice-calc.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.template" = [
          "libreoffice-calc.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
          "libreoffice-writer.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.template" = [
          "libreoffice-writer.desktop"
        ];
        "application/vnd.palm" = [ "libreoffice-writer.desktop" ];
        "application/vnd.rn-realmedia-vbr" = [ "mpv.desktop" ];
        "application/vnd.rn-realmedia" = [ "mpv.desktop" ];
        "application/vnd.stardivision.writer-global" = [ "libreoffice-writer.desktop" ];
        "application/vnd.sun.xml.base" = [ "libreoffice-base.desktop" ];
        "application/vnd.sun.xml.calc.template" = [ "libreoffice-calc.desktop" ];
        "application/vnd.sun.xml.calc" = [ "libreoffice-calc.desktop" ];
        "application/vnd.sun.xml.draw.template" = [ "libreoffice-draw.desktop" ];
        "application/vnd.sun.xml.draw" = [ "libreoffice-draw.desktop" ];
        "application/vnd.sun.xml.impress.template" = [ "libreoffice-impress.desktop" ];
        "application/vnd.sun.xml.impress" = [ "libreoffice-impress.desktop" ];
        "application/vnd.sun.xml.math" = [ "libreoffice-math.desktop" ];
        "application/vnd.sun.xml.writer.global" = [ "libreoffice-writer.desktop" ];
        "application/vnd.sun.xml.writer.template" = [ "libreoffice-writer.desktop" ];
        "application/vnd.sun.xml.writer" = [ "libreoffice-writer.desktop" ];
        "application/vnd.visio" = [ "libreoffice-draw.desktop" ];
        "application/vnd.wordperfect" = [ "libreoffice-writer.desktop" ];
        "application/wordperfect" = [ "libreoffice-writer.desktop" ];
        "application/x-123" = [ "libreoffice-calc.desktop" ];
        "application/x-abiword" = [ "libreoffice-writer.desktop" ];
        "application/x-aportisdoc" = [ "libreoffice-writer.desktop" ];
        "application/x-cue" = [ "mpv.desktop" ];
        "application/x-dbase" = [ "libreoffice-calc.desktop" ];
        "application/x-dbf" = [ "libreoffice-calc.desktop" ];
        "application/x-doc" = [ "libreoffice-writer.desktop" ];
        "application/x-dos_ms_excel" = [ "libreoffice-calc.desktop" ];
        "application/x-excel" = [ "libreoffice-calc.desktop" ];
        "application/x-extension-m4a" = [ "mpv.desktop" ];
        "application/x-extension-mp4" = [ "mpv.desktop" ];
        "application/x-extension-txt" = [ "libreoffice-writer.desktop" ];
        "application/x-fictionbook+xml" = [ "libreoffice-writer.desktop" ];
        "application/x-hwp" = [ "libreoffice-writer.desktop" ];
        "application/x-iwork-keynote-sffkey" = [ "libreoffice-impress.desktop" ];
        "application/x-iwork-numbers-sffnumbers" = [ "libreoffice-calc.desktop" ];
        "application/x-iwork-pages-sffpages" = [ "libreoffice-writer.desktop" ];
        "application/x-keepass2" = [ "org.keepassxc.KeePassXC.desktop" ];
        "application/x-matroska" = [ "mpv.desktop" ];
        "application/x-mpegurl" = [ "mpv.desktop" ];
        "application/x-ms-excel" = [ "libreoffice-calc.desktop" ];
        "application/x-mswrite" = [ "libreoffice-writer.desktop" ];
        "application/x-ogg" = [ "mpv.desktop" ];
        "application/x-ogm-audio" = [ "mpv.desktop" ];
        "application/x-ogm-video" = [ "mpv.desktop" ];
        "application/x-ogm" = [ "mpv.desktop" ];
        "application/x-pagemaker" = [ "libreoffice-draw.desktop" ];
        "application/x-pem-file" = [ "gcr-viewer.desktop" ];
        "application/x-pem-key" = [ "gcr-viewer.desktop" ];
        "application/x-pkcs12" = [ "gcr-viewer.desktop" ];
        "application/x-pkcs7-certificates" = [ "gcr-viewer.desktop" ];
        "application/x-quattropro" = [ "libreoffice-calc.desktop" ];
        "application/x-shorten" = [ "mpv.desktop" ];
        "application/x-smil" = [ "mpv.desktop" ];
        "application/x-sony-bbeb" = [ "libreoffice-writer.desktop" ];
        "application/x-spkac+base64" = [ "gcr-viewer.desktop" ];
        "application/x-spkac" = [ "gcr-viewer.desktop" ];
        "application/x-starcalc" = [ "libreoffice-calc.desktop" ];
        "application/x-stardraw" = [ "libreoffice-draw.desktop" ];
        "application/x-starwriter" = [ "libreoffice-writer.desktop" ];
        "application/x-streamingmedia" = [ "mpv.desktop" ];
        "application/x-t602" = [ "libreoffice-writer.desktop" ];
        "application/x-visual-studio-code-workspace" = [ "visual-studio-code.desktop" ];
        "application/x-wpg" = [ "libreoffice-draw.desktop" ];
        "application/x-x509-ca-cert" = [ "gcr-viewer.desktop" ];
        "application/x-x509-user-cert" = [ "gcr-viewer.desktop" ];
        "application/x-xpinstall" = [ "firefox.desktop" ];
        "application/x-zoom" = [ "Zoom.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/xhtml_xml" = [ "firefox.desktop" ];
        "application/xml" = [ "editor.desktop" ];
        "audio/3gpp2" = [ "mpv.desktop" ];
        "audio/3gpp" = [ "mpv.desktop" ];
        "audio/AMR" = [ "mpv.desktop" ];
        "audio/aac" = [ "mpv.desktop" ];
        "audio/ac3" = [ "mpv.desktop" ];
        "audio/aiff" = [ "mpv.desktop" ];
        "audio/amr-wb" = [ "mpv.desktop" ];
        "audio/dv" = [ "mpv.desktop" ];
        "audio/eac3" = [ "mpv.desktop" ];
        "audio/flac" = [ "mpv.desktop" ];
        "audio/m3u" = [ "mpv.desktop" ];
        "audio/m4a" = [ "mpv.desktop" ];
        "audio/mp1" = [ "mpv.desktop" ];
        "audio/mp2" = [ "mpv.desktop" ];
        "audio/mp3" = [ "mpv.desktop" ];
        "audio/mp4" = [ "mpv.desktop" ];
        "audio/mpeg2" = [ "mpv.desktop" ];
        "audio/mpeg3" = [ "mpv.desktop" ];
        "audio/mpeg" = [ "mpv.desktop" ];
        "audio/mpegapplication/octet-stream" = [ "mpv.desktop" ];
        "audio/mpegurl" = [ "mpv.desktop" ];
        "audio/mpg" = [ "mpv.desktop" ];
        "audio/musepack" = [ "mpv.desktop" ];
        "audio/ogg" = [ "mpv.desktop" ];
        "audio/opus" = [ "mpv.desktop" ];
        "audio/rn-mpeg" = [ "mpv.desktop" ];
        "audio/scpls" = [ "mpv.desktop" ];
        "audio/vnd.dolby.heaac.1" = [ "mpv.desktop" ];
        "audio/vnd.dolby.heaac.2" = [ "mpv.desktop" ];
        "audio/vnd.dts.hd" = [ "mpv.desktop" ];
        "audio/vnd.dts" = [ "mpv.desktop" ];
        "audio/vnd.rn-realaudio" = [ "mpv.desktop" ];
        "audio/vorbis" = [ "mpv.desktop" ];
        "audio/wav" = [ "mpv.desktop" ];
        "audio/webm" = [ "mpv.desktop" ];
        "audio/x-aac" = [ "mpv.desktop" ];
        "audio/x-adpcm" = [ "mpv.desktop" ];
        "audio/x-aiff" = [ "mpv.desktop" ];
        "audio/x-ape" = [ "mpv.desktop" ];
        "audio/x-m4a" = [ "mpv.desktop" ];
        "audio/x-matroska" = [ "mpv.desktop" ];
        "audio/x-mp1" = [ "mpv.desktop" ];
        "audio/x-mp2" = [ "mpv.desktop" ];
        "audio/x-mp3" = [ "mpv.desktop" ];
        "audio/x-mpegurl" = [ "mpv.desktop" ];
        "audio/x-mpg" = [ "mpv.desktop" ];
        "audio/x-ms-asf" = [ "mpv.desktop" ];
        "audio/x-ms-wma" = [ "mpv.desktop" ];
        "audio/x-musepack" = [ "mpv.desktop" ];
        "audio/x-pls" = [ "mpv.desktop" ];
        "audio/x-pn-au" = [ "mpv.desktop" ];
        "audio/x-pn-realaudio" = [ "mpv.desktop" ];
        "audio/x-pn-wav" = [ "mpv.desktop" ];
        "audio/x-pn-windows-pcm" = [ "mpv.desktop" ];
        "audio/x-realaudio" = [ "mpv.desktop" ];
        "audio/x-scpls" = [ "mpv.desktop" ];
        "audio/x-shorten" = [ "mpv.desktop" ];
        "audio/x-tta" = [ "mpv.desktop" ];
        "audio/x-vorbis+ogg" = [ "mpv.desktop" ];
        "audio/x-vorbis" = [ "mpv.desktop" ];
        "audio/x-wav" = [ "mpv.desktop" ];
        "audio/x-wavpack" = [ "mpv.desktop" ];
        "image/bmp" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/gif" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/jpeg" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/jpg" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/pjpeg" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/png" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/svg+xml" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/tiff" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/webp" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-bmp" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-emf" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-freehand" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-ico" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-pcx" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-png" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-portable-anymap" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-portable-bitmap" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-portable-graymap" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-portable-pixmap" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-tga" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-wmf" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/x-xbitmap" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "image/xpm" = [
          "imv-dir.desktop"
          "org.gnome.Loupe.desktop"
        ];
        "inode/directory" = [ "lf.desktop" ];
        "text/comma-separated-values" = [ "libreoffice-calc.desktop" ];
        "text/csv" = [ "libreoffice-calc.desktop" ];
        "text/english" = [ "editor.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "text/mathml" = [ "libreoffice-math.desktop" ];
        "text/plain" = [ "editor.desktop" ];
        "text/rtf" = [ "editor.desktop" ];
        "text/spreadsheet" = [ "libreoffice-calc.desktop" ];
        "text/tab-separated-values" = [ "libreoffice-calc.desktop" ];
        "text/x-c++" = [ "editor.desktop" ];
        "text/x-c++hdr" = [ "editor.desktop" ];
        "text/x-c++src" = [ "editor.desktop" ];
        "text/x-c" = [ "editor.desktop" ];
        "text/x-chdr" = [ "editor.desktop" ];
        "text/x-comma-separated-values" = [ "libreoffice-calc.desktop" ];
        "text/x-csrc" = [ "editor.desktop" ];
        "text/x-csv" = [ "libreoffice-calc.desktop" ];
        "text/x-java" = [ "editor.desktop" ];
        "text/x-makefile" = [ "editor.desktop" ];
        "text/x-moc" = [ "editor.desktop" ];
        "text/x-pascal" = [ "editor.desktop" ];
        "text/x-script.python" = [ "editor.desktop" ];
        "text/x-shellscript" = [ "editor.desktop" ];
        "text/x-tcl" = [ "editor.desktop" ];
        "text/x-tex" = [ "editor.desktop" ];
        "text/xml" = [ "editor.desktop" ];
        "video/3gp" = [ "mpv.desktop" ];
        "video/3gpp2" = [ "mpv.desktop" ];
        "video/3gpp" = [ "mpv.desktop" ];
        "video/avi" = [ "mpv.desktop" ];
        "video/divx" = [ "mpv.desktop" ];
        "video/dv" = [ "mpv.desktop" ];
        "video/fli" = [ "mpv.desktop" ];
        "video/flv" = [ "mpv.desktop" ];
        "video/mkv" = [ "mpv.desktop" ];
        "video/mp2t" = [ "mpv.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "video/mp4v-es" = [ "mpv.desktop" ];
        "video/mpeg" = [ "mpv.desktop" ];
        "video/msvideo" = [ "mpv.desktop" ];
        "video/ogg" = [ "mpv.desktop" ];
        "video/quicktime" = [ "mpv.desktop" ];
        "video/vnd.divx" = [ "mpv.desktop" ];
        "video/vnd.mpegurl" = [ "mpv.desktop" ];
        "video/vnd.rn-realvideo" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-avi" = [ "mpv.desktop" ];
        "video/x-flc" = [ "mpv.desktop" ];
        "video/x-flic" = [ "mpv.desktop" ];
        "video/x-flv" = [ "mpv.desktop" ];
        "video/x-m4v" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "video/x-mpeg2" = [ "mpv.desktop" ];
        "video/x-mpeg3" = [ "mpv.desktop" ];
        "video/x-ms-afs" = [ "mpv.desktop" ];
        "video/x-ms-asf" = [ "mpv.desktop" ];
        "video/x-ms-wmv" = [ "mpv.desktop" ];
        "video/x-ms-wmx" = [ "mpv.desktop" ];
        "video/x-ms-wvxvideo" = [ "mpv.desktop" ];
        "video/x-msvideo" = [ "mpv.desktop" ];
        "video/x-ogm+ogg" = [ "mpv.desktop" ];
        "video/x-ogm" = [ "mpv.desktop" ];
        "video/x-theora+ogg" = [ "mpv.desktop" ];
        "video/x-theora" = [ "mpv.desktop" ];
        "x-scheme-handler/callto" = [ "Zoom.desktop" ];
        "x-scheme-handler/ftp" = [ "editor.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/molotov" = [ "appimagekit-molotov.desktop" ];
        "x-scheme-handler/qute" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/steam" = [ "steam.desktop" ];
        "x-scheme-handler/steamlink" = [ "steam.desktop" ];
        "x-scheme-handler/tel" = [ "Zoom.desktop" ];
        "x-scheme-handler/vnd.libreoffice.cmis" = [ "libreoffice-startcenter.desktop" ];
        "x-scheme-handler/vscode" = [ "visual-studio-code-url-handler.desktop" ];
        "x-scheme-handler/zoommtg" = [ "Zoom.desktop" ];
        "x-scheme-handler/zoomphonecall" = [ "Zoom.desktop" ];
        "x-scheme-handler/zoomus" = [ "Zoom.desktop" ];
      };
    };
  };
}
