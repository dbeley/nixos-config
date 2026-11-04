{ pkgs, ... }:
let
  preview = pkgs.writeShellApplication {
    name = "ytq-preview";
    runtimeInputs = with pkgs; [
      chafa
      curl
    ];
    text = ''
      id=$(printf '%s' "''${1:-}" | tr -cd 'A-Za-z0-9_-')
      [ -n "$id" ] || exit 0

      cache="''${XDG_CACHE_HOME:-$HOME/.cache}/ytq"
      mkdir -p "$cache"
      img="$cache/$id.jpg"

      if [ ! -s "$img" ]; then
        curl -fsSL --max-time 10 \
          "https://i.ytimg.com/vi/$id/mqdefault.jpg" -o "$img" || exit 0
      fi

      exec chafa --size "''${FZF_PREVIEW_COLUMNS:-60}x''${FZF_PREVIEW_LINES:-20}" "$img"
    '';
  };

  ytq = pkgs.writeShellApplication {
    name = "ytq";
    runtimeInputs = with pkgs; [
      fzf
      yt-dlp
      gawk
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

      mapfile -d "" -t results < <(
        yt-dlp "ytsearch$n:$query" --flat-playlist --no-warnings \
          --print "%(duration_string)s│%(view_count)s│%(channel)s│%(title)s│%(id)s" |
          awk -F'│' '
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

              # Un « │ » dans le texte casserait les champs : on le remplace.
              title = $4
              for (i = 5; i < NF; i++) title = title "│" $i
              gsub(/│/, "¦", title)

              meta = ($1 == "" || $1 == "NA") ? "" : $1
              if ($2 != "" && $2 != "NA") meta = (meta == "" ? "" : meta " · ") human($2) " vues"
              if ($3 != "" && $3 != "NA") meta = (meta == "" ? "" : meta " · ") $3
              gsub(/│/, "¦", meta)

              printf "%s│%s\n   %s%c", id, title, meta, 0
            }
          ' || true
      )

      if [ "''${#results[@]}" -eq 0 ]; then
        echo "ytq: aucun résultat pour « $query »" >&2
        exit 1
      fi

      urls=()
      chosen=()
      mapfile -d "" -t chosen < <(
        printf '%s\0' "''${results[@]}" |
          fzf --read0 --print0 --reverse --height=100% --prompt='yt> ' \
            --multi --marker='✔ ' --ellipsis='…' \
            --delimiter='│' --with-nth=2 --nth=2 \
            --header='Tab : cocher plusieurs · Entrée : télécharger' \
            --preview="${preview}/bin/ytq-preview {1}" \
            --preview-window='right,45%,border-left'
      )

      [ "''${#chosen[@]}" -gt 0 ] || exit 130

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
