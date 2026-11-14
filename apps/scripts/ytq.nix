{ pkgs, ... }:
let
  youtubeApi = pkgs.callPackage ./api.nix { };
  ytdlp = pkgs.callPackage ./ytdlp.nix { };

  preview = pkgs.callPackage ./yt-preview.nix {
    name = "ytq-preview";
    cacheDir = "ytq";
  };

  ytRows = pkgs.callPackage ./yt-rows.nix { };

  list = pkgs.writeShellApplication {
    name = "ytq-list";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      gnugrep
      jq
      youtubeApi
      ytRows
    ];
    text = ''
      state=$1
      action=''${2:-first}

      # les étiquettes renvoyées par YouTube (« 686,562 views ») sont
      # analysées par yt-rows : on fixe la langue du client pour que leur
      # format ne dépende pas d'un YT_HL hérité de l'environnement
      export YT_HL=en YT_GL=US

      # « EgIQAQ== » = filtre « vidéos » de YouTube : les playlists, chaînes
      # et mixes de la recherche sont écartés à la source
      params='EgIQAQ=='

      query=$(cat "$state/query")
      want=$(cat "$state/want")

      if [ "$action" = first ]; then
        : > "$state/ids"
        : > "$state/raw"
        : > "$state/meta"
        : > "$state/token"
      fi

      tmp=$(mktemp -d)
      trap 'rm -rf "$tmp"' EXIT

      # id, durée, vues, chaîne, titre (champs séparés par \x1f)
      cat > "$tmp/rows.jq" <<'JQ'
      [.. | objects | select(has("videoRenderer")) | .videoRenderer]
      | map(select((.videoId // "") | test("^[A-Za-z0-9_-]{11}$")))
      | map([ .videoId,
              (.lengthText.simpleText // ""),
              (.viewCountText.simpleText // ""),
              (.ownerText.runs[0].text // .longBylineText.runs[0].text // ""),
              (.title.runs[0].text // .title.simpleText // "") ]
            | map(gsub("[\u0000\t\n]"; " ") | gsub("│"; "¦"))
            | join("\u001f"))
      | .[]
      JQ

      # page suivante : le jeton de la fin de la liste (et non ceux des
      # filtres, rangés dans chipBar)
      cat > "$tmp/token.jq" <<'JQ'
      ([.. | objects | select(has("appendContinuationItemsAction"))][0]
       | .appendContinuationItemsAction.continuationItems[]?
       | select(has("continuationItemRenderer"))
       | .continuationItemRenderer.continuationEndpoint.continuationCommand.token)
       //
      ([.. | objects | select(has("sectionListRenderer"))][0]
       | .sectionListRenderer.contents[]?
       | select(has("continuationItemRenderer"))
       | .continuationItemRenderer.continuationEndpoint.continuationCommand.token)
       // ""
      JQ

      pages=0
      while :; do
        token=$(cat "$state/token" 2>/dev/null || true)

        if [ "$action" = next ]; then
          if [ -z "$token" ]; then
            printf 'Fin de la liste : plus rien à charger\n' > "$state/notice"
            break
          fi
        elif [ "$pages" -gt 0 ]; then
          # premier chargement : au moins une page, puis jusqu'au nombre demandé
          if [ -z "$token" ] || [ "$(wc -l < "$state/ids")" -ge "$want" ]; then
            break
          fi
        fi

        if [ -n "$token" ]; then
          payload=$(jq -nc --arg t "$token" '{continuation: $t}')
        else
          payload=$(jq -nc --arg q "$query" --arg p "$params" '{query: $q, params: $p}')
        fi
        pages=$((pages + 1))

        if ! youtube-api raw search "$payload" > "$tmp/page"; then
          if [ ! -s "$state/raw" ]; then
            echo "ytq: YouTube n'a pas répondu" >&2
            exit 1
          fi
          printf "YouTube n'a pas répondu - Ctrl-N pour réessayer\n" > "$state/notice"
          break
        fi
        rm -f "$state/notice"

        jq -r -f "$tmp/rows.jq" "$tmp/page" > "$tmp/rows" 2>/dev/null || true
        jq -r -f "$tmp/token.jq" "$tmp/page" > "$state/token" 2>/dev/null || : > "$state/token"

        : > "$tmp/new"
        while IFS=$'\x1f' read -r id dur views chan title; do
          [ -n "$id" ] || continue
          if [ -s "$state/ids" ] && grep -qxF -- "$id" "$state/ids"; then
            continue
          fi
          printf '%s\n' "$id" >> "$state/ids"
          printf '%s\x1f%s\x1f%s\x1f%s\x1f%s\n' "$id" "$dur" "$views" "$chan" "$title" >> "$state/raw"
          printf '%s\n' "$id" >> "$tmp/new"
        done < "$tmp/rows"

        # date de publication : une requête « player » par vidéo, mise en cache
        if [ -s "$tmp/new" ]; then
          mapfile -t new_ids < "$tmp/new"
          youtube-api meta "''${new_ids[@]}" 2>/dev/null \
            | gawk -F'│' 'NF >= 3 { print $1 "\x1f" $2 "\x1f" $3 }' >> "$state/meta" || true
        fi

        if [ "$action" = next ]; then
          break
        fi

        # jeton inchangé : YouTube répète la page, inutile d'insister
        if [ -n "$token" ] && [ "$(cat "$state/token")" = "$token" ]; then
          : > "$state/token"
        fi
      done

      # id -> date : la durée vient aussi de « meta » (même source que ytf)
      gawk -F'\x1f' '
        FILENAME == ARGV[1] { ep[$1] = $2; sec[$1] = $3; next }
        { printf "%s\x1f%s\x1f%s\x1f%s\x1f%s\x1f%s\n", $1, ep[$1], ($1 in sec ? sec[$1] : $2), $3, $4, $5 }
      ' "$state/meta" "$state/raw" | yt-rows
    '';
  };

  stats = pkgs.writeShellApplication {
    name = "ytq-stats";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      state=$1
      if [ -s "$state/notice" ]; then
        cat "$state/notice"
        : > "$state/notice"
      fi
      n=$(wc -l < "$state/ids" 2>/dev/null || echo 0)
      printf 'Recherche : %s · %s résultats\n' "$(cat "$state/query")" "$n"
      printf 'Tab cocher · Entrée télécharger · Ctrl-N +20 · Ctrl-R nouvelle recherche\n'
    '';
  };

  ytq = pkgs.writeShellApplication {
    name = "ytq";
    runtimeInputs = with pkgs; [
      fzf
      ytdlp
      coreutils
    ];
    text = ''
      usage() {
        cat <<'EOF'
      usage: ytq [-n N] [recherche]

        Cherche sur YouTube, choisit un ou plusieurs résultats avec fzf
        (vignette dans le volet de droite, date, durée, vues et chaîne),
        puis les télécharge avec ytdl (voir ytdlp), dans le dossier courant.

        Tab     coche/décoche un résultat ; Entrée télécharge toute la
                sélection (une seule vidéo si rien n'est coché).
        Ctrl-N  charge 20 résultats supplémentaires.
        Ctrl-R  lance une nouvelle recherche sans quitter ytq.

                Qualité : 720p maximum, en H.264 30 fps.
                Régler YT_MAX_HEIGHT=480 pour alléger encore le décodage.
                Langue : la piste originale est toujours choisie (jamais
                un doublage automatique).
                Cookies : un navigateur connecté à YouTube est utilisé
                automatiquement pour télécharger (variables YT_COOKIES ou
                YT_COOKIES_FROM_BROWSER pour forcer, voir ytdlp).

        Seules les vidéos sont proposées : les playlists, chaînes et
        mixes renvoyés par la recherche YouTube sont écartés.

        -n N   nombre de résultats chargés d'emblée (défaut : 20)
               pas de maximum imposé : les pages de ~20 résultats
               s'enchaînent, une requête chacune
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
        printf '%s' "$n" > "$state/want"

        printf 'Recherche : %s…\n' "$query" >&2
        "${list}/bin/ytq-list" "$state" first > "$state/list"

        if [ ! -s "$state/list" ]; then
          echo "ytq: aucun résultat pour « $query »" >&2
          exit 1
        fi

        mapfile -d "" -t picked < <(
          fzf --read0 --print0 --reverse --height=100% --prompt='yt> ' \
            --expect=ctrl-r --multi --marker='✔ ' --ellipsis='…' \
            --delimiter='│' --with-nth=2 --track --id-nth=1 \
            --header="$("${stats}/bin/ytq-stats" "$state")" \
            --bind "ctrl-n:reload-sync(${list}/bin/ytq-list $state next)+transform-header(${stats}/bin/ytq-stats $state)" \
            --preview="${preview}/bin/ytq-preview {1}" \
            --preview-window='right,45%,border-left' \
            < "$state/list"
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

      exec ytdl "''${urls[@]}"
    '';
  };
in
{
  home.packages = [ ytq ];
}
