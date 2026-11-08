{ pkgs, config, ... }:
let
  youtubeApi = pkgs.callPackage ./api.nix { };

  defaultFile = "${config.home.homeDirectory}/Nextcloud/10-19_Documents/18_Config/18.25_ytf/channels.txt";

  preview = pkgs.callPackage ./yt-preview.nix {
    name = "ytf-preview";
    cacheDir = "ytf/thumbs";
  };

  edit = pkgs.writeShellApplication {
    name = "ytf-edit";
    runtimeInputs = with pkgs; [ vim ];
    text = ''
      editor="''${EDITOR:-vi}"
      exec "$editor" "''${1:?}"
    '';
  };

  stats = pkgs.writeShellApplication {
    name = "ytf-stats";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      cache="''${XDG_CACHE_HOME:-$HOME/.cache}/ytf"
      if [ -s "$cache/last-stats" ]; then
        printf '%s · rafraîchi à %s\n' "$(cat "$cache/last-stats")" "$(date '+%H:%M')"
      else
        printf 'aucune chaîne chargée\n'
      fi
    '';
  };

  list = pkgs.writeShellApplication {
    name = "ytf-list";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      gawk
      youtubeApi
    ];
    text = ''
      file="''${YTF_FILE:-${defaultFile}}"
      cache="''${XDG_CACHE_HOME:-$HOME/.cache}/ytf"
      err="$cache/last-err"
      mkdir -p "$cache"
      : > "$err"

      tmp=$(mktemp -d)
      trap 'rm -rf "$tmp"' EXIT

      mapfile -t inputs < <(
        awk '{ sub(/\r$/, "") }
             /^[[:space:]]*#/ { next }
             { gsub(/^[[:space:]]+/, ""); gsub(/[[:space:]]+$/, ""); if ($0 != "") print }' "$file" 2>/dev/null
      )
      if [ "''${#inputs[@]}" -eq 0 ]; then
        echo "ytf: aucun canal dans $file" >&2
        exit 1
      fi

      ids=()
      while IFS='│' read -r input id; do
        if [ "$id" = '!' ] || [ -z "$id" ]; then
          echo "ytf: canal introuvable : $input" >> "$err"
          continue
        fi
        ids+=("$id")
      done < <(youtube-api resolve "''${inputs[@]}")

      if [ "''${#ids[@]}" -eq 0 ]; then
        echo "ytf: aucun canal résolu (voir $file)" >&2
        exit 1
      fi
      mapfile -t ids < <(printf '%s\n' "''${ids[@]}" | awk '!seen[$0]++')

      pending=("''${!ids[@]}")
      total="''${#pending[@]}"
      max_parallel=4
      throttled=0
      if [ "$total" -gt 0 ]; then
        for attempt in 1 2; do
          [ "''${#pending[@]}" -gt 0 ] || break
          args=()
          for i in "''${pending[@]}"; do
            args+=(-o "$tmp/feed_$i.xml" "https://www.youtube.com/feeds/videos.xml?channel_id=''${ids[$i]}")
          done
          curl -fsS --parallel --parallel-max "$max_parallel" -m 20 "''${args[@]}" 2>/dev/null || true
          failed=()
          for i in "''${pending[@]}"; do
            [ -s "$tmp/feed_$i.xml" ] || failed+=("$i")
          done
          pending=("''${failed[@]}")
          # a third of the channels failing at once is not a per-channel problem:
          # YouTube answers 404 to the whole feed endpoint when it throttles us,
          # so retrying would only make the run long for nothing.
          if [ "''${#pending[@]}" -eq 0 ]; then
            break
          fi
          if [ "''${#pending[@]}" -ge 8 ] && [ "$(( ''${#pending[@]} * 3 ))" -gt "$total" ]; then
            echo "ytf: ''${#pending[@]}/$total flux refusés — YouTube limite probablement les requêtes (HTTP 404/429), réessayez plus tard" >> "$err"
            throttled=1
            break
          fi
          max_parallel=4
          sleep "$attempt"
        done
      fi

      for i in "''${pending[@]}"; do
        if [ "$throttled" -eq 1 ]; then
          break
        fi
        if [ -s "$tmp/feed_$i.xml" ]; then
          continue
        fi
        code=$(curl -sS -o "$tmp/feed_$i.xml" -w '%{http_code}' -m 20 \
          "https://www.youtube.com/feeds/videos.xml?channel_id=''${ids[$i]}") || code=000
        if [ "$code" = 200 ] && [ -s "$tmp/feed_$i.xml" ]; then
          continue
        fi
        rm -f "$tmp/feed_$i.xml"
        if [ "$code" = 404 ]; then
          echo "ytf: pas de flux pour ''${ids[$i]} (404 : chaîne sans flux)" >> "$err"
        else
          echo "ytf: flux indisponible pour ''${ids[$i]} (HTTP $code)" >> "$err"
        fi
      done

      feeds=()
      for i in "''${!ids[@]}"; do
        if [ -s "$tmp/feed_$i.xml" ]; then
          feeds+=("$tmp/feed_$i.xml")
        fi
      done
      if [ "''${#feeds[@]}" -eq 0 ]; then
        [ -s "$err" ] && cat "$err" >&2
        echo "ytf: aucun flux récupéré" >&2
        exit 1
      fi

      TZ=UTC gawk '
        BEGIN { RS = "<entry>"; now = systime(); cutoff = now - 14 * 86400 }

        function unesc(s) {
          gsub(/&lt;/, "<", s); gsub(/&gt;/, ">", s); gsub(/&quot;/, "\"", s)
          gsub(/&#39;/, sprintf("%c", 39), s); gsub(/&amp;/, "\\&", s)
          return s
        }
        function clean(s) { gsub(/│/, "¦", s); return unesc(s) }

        FNR == 1 { next }

        {
          if (!match($0, /<yt:videoId>[^<]+<\/yt:videoId>/)) next
          vid = substr($0, RSTART + 12, RLENGTH - 25)
          if (!match($0, /<published>[^<]+<\/published>/)) next
          split(substr($0, RSTART + 11, RLENGTH - 23), d, /[T:+-]/)
          t = mktime(d[1] " " d[2] " " d[3] " " d[4] " " d[5] " 0", 1)
          if (t <= 0) next
          if (!match($0, /<name>[^<]*<\/name>/)) next
          chan = clean(substr($0, RSTART + 6, RLENGTH - 13))
          if (!match($0, /<title>[^<]*<\/title>/)) next
          title = clean(substr($0, RSTART + 7, RLENGTH - 15))
          views = ""
          if (match($0, /<media:statistics views="[0-9]+"/)) views = substr($0, RSTART + 26, RLENGTH - 27)

          total[FILENAME]++
          if (t >= cutoff) recent[FILENAME]++
          named[FILENAME] = chan
          print t "\x1f" vid "\x1f" chan "\x1f" views "\x1f" title
        }

        END {
          for (f in total) if (recent[f] >= 15)
            printf "ytf: %s a 15 vidéos dans les 14 derniers jours, il peut y en avoir plus\n", named[f] > "/dev/stderr"
        }
      ' "''${feeds[@]}" 2>> "$err" |
        sort -t $'\x1f' -k1,1nr |
        awk -F'\x1f' '!seen[$2]++' > "$tmp/sorted"

      n_videos=$(wc -l < "$tmp/sorted")
      if [ "$n_videos" -eq 0 ]; then
        echo "ytf: aucune vidéo dans les flux" >&2
        exit 1
      fi

      gawk -F'\x1f' '
        function human(v,   n) {
          n = v + 0
          if (n >= 1000000000) return sprintf("%.1f Md", n / 1000000000)
          if (n >= 1000000) return sprintf("%.1f M", n / 1000000)
          if (n >= 1000) return sprintf("%.0f k", n / 1000)
          return sprintf("%d", n)
        }
        {
          meta = ($4 == "") ? $3 : human($4) " vues · " $3
          printf "%s│%s  %s\n   %s%c", $2, strftime("%Y-%m-%d %H:%M", $1 + 0), $5, meta, 0
        }
      ' "$tmp/sorted"

      printf '%s chaînes · %s vidéos' "''${#ids[@]}" "$n_videos" > "$cache/last-stats"
    '';
  };

  ytf = pkgs.writeShellApplication {
    name = "ytf";
    runtimeInputs = with pkgs; [
      coreutils
      fzf
      yt-dlp
    ];
    text = ''
      usage() {
        cat <<'EOF'
      usage: ytf [-f FICHIER]

        Affiche les dernières vidéos des chaînes YouTube listées dans un fichier,
        une par ligne (URL de chaîne, @handle ou identifiant UC…), les lignes
        commençant par # étant ignorées. Les flux sont fusionnés et triés de la
        plus récente à la plus ancienne, puis présentés dans fzf avec la vignette
        et la date de publication.

        Tab     coche/décoche une vidéo ; Entrée télécharge la sélection
                (une seule vidéo si rien n'est coché), en 720p maximum, H.264.
        Ctrl-R  recharge les flux.
        Ctrl-O  édite le fichier des chaînes, puis recharge.

        Chaque flux YouTube ne contient que les 15 dernières vidéos : si une
        chaîne publie davantage, seules les 15 plus récentes apparaissent (un
        avertissement le signale).

        -f FICHIER  fichier des chaînes
                    (défaut : $YTF_FILE, sinon ${defaultFile})
        -h          affiche cette aide
      EOF
      }

      file="''${YTF_FILE:-${defaultFile}}"
      while getopts ":f:h" opt; do
        case $opt in
          f) file=$OPTARG ;;
          h)
            usage
            exit 0
            ;;
          :)
            echo "ytf: -$OPTARG attend un argument" >&2
            exit 2
            ;;
          *)
            usage >&2
            exit 2
            ;;
        esac
      done
      shift $((OPTIND - 1))
      export YTF_FILE=$file

      cache="''${XDG_CACHE_HOME:-$HOME/.cache}/ytf"
      mkdir -p "$cache"

      if [ ! -f "$file" ]; then
        echo "ytf: fichier introuvable : $file" >&2
        exit 1
      fi

      state=$(mktemp -d)
      trap 'rm -rf "$state"' EXIT

      while :; do
        if ! ${list}/bin/ytf-list > "$state/list"; then
          [ -s "$cache/last-err" ] && cat "$cache/last-err" >&2
          exit 1
        fi
        if [ ! -s "$state/list" ]; then
          [ -s "$cache/last-err" ] && cat "$cache/last-err" >&2
          echo "ytf: aucune vidéo" >&2
          exit 1
        fi
        if [ -s "$cache/last-err" ]; then
          cat "$cache/last-err" >&2
        fi

        header="$(cat "$cache/last-stats" 2>/dev/null)"$'\n'"Tab cocher · Entrée télécharger · Ctrl-R rafraîchir · Ctrl-O éditer les chaînes"

        mapfile -d "" -t picked < <(
          fzf --read0 --print0 --reverse --height=100% --prompt='ytf> ' \
            --expect=ctrl-o --multi --marker='✔ ' --ellipsis='…' \
            --delimiter='│' --with-nth=2 --track --id-nth=1 \
            --header="$header" \
            --bind "ctrl-r:reload-sync(${list}/bin/ytf-list)+transform-header(${stats}/bin/ytf-stats)" \
            --preview="${preview}/bin/ytf-preview {1}" \
            --preview-window='right,45%,border-left' \
            < "$state/list"
        )

        key="''${picked[0]:-}"
        chosen=("''${picked[@]:1}")
        if [ "$key" = ctrl-o ]; then
          ${edit}/bin/ytf-edit "$file"
          continue
        fi
        break
      done
      if [ "''${#chosen[@]}" -eq 0 ]; then
        exit 130
      fi

      urls=()
      for item in "''${chosen[@]}"; do
        urls+=("https://youtu.be/''${item%%│*}")
      done

      exec yt-dlp -f 'bv*[height<=720][vcodec^=avc1]+ba[ext=m4a]/bv*[height<=720][vcodec^=avc1]+ba/b[height<=720][vcodec^=avc1]/bv*[height<=720]+ba/b[height<=720]/b' \
        -S tbr "''${urls[@]}"
    '';
  };
in
{
  home.packages = [ ytf ];
}
