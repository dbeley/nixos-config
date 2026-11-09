{ pkgs, ... }:
let
  ytDlp = pkgs.yt-dlp;

  ytdlp = pkgs.writeShellApplication {
    name = "ytdlp";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      cfg="''${XDG_CONFIG_HOME:-$HOME/.config}"

      args=()

      have_profile() { # $1 = chromium-like browser dir, cookies live in <dir>/*/Cookies
        local d
        for d in "$1"/*/Cookies; do
          [ -f "$d" ] && return 0
        done
        return 1
      }

      if [ -n "''${YT_COOKIES:-}" ]; then
        args=(--cookies "$YT_COOKIES")
      elif [ -n "''${YT_COOKIES_FROM_BROWSER:-}" ]; then
        args=(--cookies-from-browser "$YT_COOKIES_FROM_BROWSER")
      elif [ -f "$cfg/yt-dlp/cookies.txt" ]; then
        args=(--cookies "$cfg/yt-dlp/cookies.txt")
      elif [ -s "$HOME/.mozilla/firefox/profiles.ini" ]; then
        args=(--cookies-from-browser firefox)
      elif have_profile "$cfg/chromium"; then
        case "''${XDG_CURRENT_DESKTOP:-}" in
          *KDE*) args=(--cookies-from-browser chromium) ;;
          *) args=(--cookies-from-browser chromium+gnomekeyring) ;;
        esac
      elif have_profile "$cfg/google-chrome"; then
        args=(--cookies-from-browser chrome)
      elif have_profile "$cfg/BraveSoftware/Brave-Browser"; then
        args=(--cookies-from-browser brave)
      fi

      args+=(--extractor-args 'youtube:player_client=default,-web_embedded')

      exec ${ytDlp}/bin/yt-dlp "''${args[@]}" "$@"
    '';
  };

  ytdl = pkgs.writeShellApplication {
    name = "ytdl";
    runtimeInputs = [ ytdlp ];
    text = ''
      maxh="''${YT_MAX_HEIGHT:-720}"
      exec ytdlp \
        -f "bv*[height<=$maxh]+ba[ext=m4a]/b[height<=$maxh]/b" \
        -S "lang,res:$maxh,fps:30,vcodec:avc1" \
        --concurrent-fragments 4 \
        "$@"
    '';
  };
in
pkgs.symlinkJoin {
  name = "ytdlp";
  paths = [
    ytdlp
    ytdl
  ];
}
