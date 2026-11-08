{ pkgs, ... }:
let
  youtubeApi = pkgs.callPackage ./api.nix { };

  preview = pkgs.callPackage ./yt-preview.nix {
    name = "ytq-preview";
    cacheDir = "ytq";
  };

  list = pkgs.writeShellApplication {
    name = "ytq-list";
    runtimeInputs = with pkgs; [
      yt-dlp
      gawk
      coreutils
      youtubeApi
    ];
    text = ''
      tmp=$(mktemp -d)
      trap 'rm -rf "$tmp"' EXIT

      if [ "''${1:-}" = "--next" ]; then
        dir=$2
        n=$(cat "$dir/n")
        n=$((n + 20))
        printf '%s\n' "$n" > "$dir/n"
        query=$(cat "$dir/query")
      else
        query=$1
        n=$2
      fi

      yt-dlp "ytsearch$n:$query" --flat-playlist --no-warnings \
        --print "%(duration_string)s│%(view_count)s│%(channel)s│%(title)s│%(id)s" > "$tmp/raw" || true

      mapfile -t ids < <(awk -F'│' 'length($NF) == 11 { print $NF }' "$tmp/raw" | sort -u)
      : > "$tmp/meta"
      if [ "''${#ids[@]}" -gt 0 ]; then
        youtube-api meta "''${ids[@]}" > "$tmp/meta" 2>/dev/null || true
      fi

      gawk -F'│' '
        # fichier des dates : id -> « 2026-10-30 20:30 »
        FILENAME == ARGV[1] { if (NF >= 2) date[$1] = $2; next }

        function human(v,   n) {
          n = v + 0
          if (n >= 1000000000) return sprintf("%.1f Md", n / 1000000000)
          if (n >= 1000000) return sprintf("%.1f M", n / 1000000)
          if (n >= 1000) return sprintf("%.0f k", n / 1000)
          return sprintf("%d", n)
        }
        {
          id = $NF
          if (length(id) != 11) next

          title = $4
          for (i = 5; i < NF; i++) title = title "│" $i
          gsub(/│/, "¦", title)

          meta = ($1 == "" || $1 == "NA") ? "" : $1
          if ($2 != "" && $2 != "NA") meta = (meta == "" ? "" : meta " · ") human($2) " vues"
          if ($3 != "" && $3 != "NA") meta = (meta == "" ? "" : meta " · ") $3
          gsub(/│/, "¦", meta)

          d = (id in date) ? date[id] : ""
          printf "%s│%-16s  %s\n   %s%c", id, d, title, meta, 0
        }
      ' "$tmp/meta" "$tmp/raw" || true
    '';
  };

  ytq = pkgs.writeShellApplication {
    name = "ytq";
    runtimeInputs = with pkgs; [
      fzf
      yt-dlp
      coreutils
    ];
    text = ''
      usage() {
        cat <<'EOF'
      usage: ytq [-n N] [recherche]

        Cherche sur YouTube avec yt-dlp, choisit un ou plusieurs résultats
        avec fzf (vignette dans le volet de droite), puis les télécharge
        avec yt-dlp (options par défaut, dans le dossier courant).

        Tab     coche/décoche un résultat ; Entrée télécharge toute la
                sélection (une seule vidéo si rien n'est coché).
        Ctrl-N  charge 20 résultats supplémentaires.
        Ctrl-R  lance une nouvelle recherche sans quitter ytq.

                Qualité : 720p maximum, en H.264 30 fps.

        Seules les vidéos sont proposées : les playlists, chaînes et
        mixes renvoyés par la recherche YouTube sont écartés.

        -n N   nombre de résultats proposés (défaut : 20)
               pas de maximum imposé : YouTube renvoie ~20 résultats
               par page, compter ~2 s de plus par page (n=200 ≈ 20 s)
        -h     affiche cette aide

      Sans argument, la recherche est demandée interactivement.
      EOF
      }

      n=20
      while getopts ":n:h" opt; do
        case $opt in
          n) n=$OPTARG ;;
          h)
            usage
            exit 0
            ;;
          :)
            echo "ytq: -$OPTARG attend un argument" >&2
            exit 2
            ;;
          *)
            usage >&2
            exit 2
            ;;
        esac
      done
      shift $((OPTIND - 1))

      query="$*"
      if [ -z "$query" ]; then
        printf 'Recherche YouTube : '
        read -r query
      fi
      [ -n "$query" ] || exit 1
      base_n=$n

      state=$(mktemp -d)
      trap 'rm -rf "$state"' EXIT

      while :; do
        printf '%s' "$query" > "$state/query"
        printf '%s' "$n" > "$state/n"

        printf 'Recherche : %s…\n' "$query" >&2
        "${list}/bin/ytq-list" "$query" "$n" > "$state/results"

        if [ ! -s "$state/results" ]; then
          echo "ytq: aucun résultat pour « $query »" >&2
          exit 1
        fi

        mapfile -d "" -t picked < <(
          fzf --read0 --print0 --reverse --height=100% --prompt='yt> ' \
            --expect=ctrl-r --multi --marker='✔ ' --ellipsis='…' \
            --delimiter='│' --with-nth=2 --track --id-nth=1 \
            --header="Recherche : $query"$'\n'"Tab cocher · Entrée télécharger"$'\n'"Ctrl-N +20 · Ctrl-R nouvelle recherche" \
            --bind "ctrl-n:reload-sync(${list}/bin/ytq-list --next $state)" \
            --preview="${preview}/bin/ytq-preview {1}" \
            --preview-window='right,45%,border-left' \
            < "$state/results"
        )

        key="''${picked[0]:-}"
        if [ "$key" = ctrl-r ]; then
          printf 'Nouvelle recherche YouTube : '
          read -r query
          [ -n "$query" ] || exit 1
          n=$base_n
          continue
        fi

        if [ "''${#picked[@]}" -eq 0 ]; then
          exit 130
        fi
        chosen=("''${picked[@]:1}")
        break
      done

      [ "''${#chosen[@]}" -gt 0 ] || exit 130

      urls=()
      for item in "''${chosen[@]}"; do
        urls+=("https://youtu.be/''${item%%│*}")
      done

      [ "''${#urls[@]}" -gt 0 ] || exit 130

      yt-dlp -f 'bv*[height<=720][vcodec^=avc1]+ba[ext=m4a]/bv*[height<=720][vcodec^=avc1]+ba/b[height<=720][vcodec^=avc1]/bv*[height<=720]+ba/b[height<=720]/b' \
        -S tbr "''${urls[@]}"
    '';
  };
in
{
  home.packages = [ ytq ];
}
