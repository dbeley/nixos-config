{ pkgs, config, ... }:
let
  youtubeApi = pkgs.callPackage ./api.nix { };
  ytdlp = pkgs.callPackage ./ytdlp.nix { };

  defaultFile = "${config.home.homeDirectory}/Nextcloud/10-19_Documents/18_Config/18.25_ytf/channels.txt";

  preview = pkgs.callPackage ./yt-preview.nix {
    name = "ytc-preview";
    cacheDir = "ytc/thumbs";
  };

  list = pkgs.writeShellApplication {
    name = "ytc-list";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      jq
      youtubeApi
    ];
    text = ''
      state=$1
      action=''${2:-first}

      # dates et nombres de vues dans la langue de l'interface
      export YT_HL=''${YT_HL:-fr} YT_GL=''${YT_GL:-FR}

      [ -s "$state/cid" ] || { echo "ytc-list: chaîne inconnue" >&2; exit 1; }
      cid=$(cat "$state/cid")
      sort=$(cat "$state/sort" 2>/dev/null || echo latest)

      # params of a channel's "Videos" tab, as used by youtube.com itself:
      # default order (newest first), and the "Popular videos" sort
      params_of() {
        if [ "$1" = popular ]; then
          printf '%s' 'EgZ2aWRlb3MYASAAcAPyBg0KCzoEIgIIAqIBAggB'
        else
          printf '%s' 'EgZ2aWRlb3PyBgQKAjoA'
        fi
      }

      if [ "$action" = flip ]; then
        if [ "$sort" = popular ]; then sort=latest; else sort=popular; fi
        printf '%s\n' "$sort" > "$state/sort"
        action=first
      fi
      [ "$sort" = popular ] || sort=latest
      params=$(params_of "$sort")

      token=""
      case $action in
        first)
          : > "$state/items"
          : > "$state/ids"
          : > "$state/token"
          ;;
        next)
          token=$(cat "$state/token" 2>/dev/null || true)
          ;;
        *)
          echo "ytc-list: action inconnue : $action" >&2
          exit 2
          ;;
      esac

      if [ "$action" = next ] && [ -z "$token" ]; then
        printf 'Fin de la liste : plus rien à charger\n' > "$state/notice"
        cat "$state/items"
        exit 0
      fi

      tmp=$(mktemp -d)
      trap 'rm -rf "$tmp"' EXIT

      if [ -n "$token" ]; then
        payload=$(jq -nc --arg t "$token" '{continuation: $t}')
      else
        payload=$(jq -nc --arg c "$cid" --arg p "$params" '{browseId: $c, params: $p}')
      fi

      if ! youtube-api raw browse "$payload" > "$tmp/page"; then
        if [ "$action" = first ]; then
          echo "ytc: YouTube n'a pas répondu" >&2
          exit 1
        fi
        printf "YouTube n'a pas répondu — Ctrl-N pour réessayer\n" > "$state/notice"
        cat "$state/items"
        exit 0
      fi
      rm -f "$state/notice"

      if [ -z "$token" ]; then
        jq -r '.metadata.channelMetadataRenderer.title // empty' "$tmp/page" \
          > "$tmp/title" 2>/dev/null || true
        if [ -s "$tmp/title" ]; then
          mv "$tmp/title" "$state/title"
        fi
      fi

      # one line per video, fields separated by \x1f (id, date, durée, vues, titre)
      cat > "$tmp/rows.jq" <<'JQ'
      def items:
        ([.. | objects | select(has("appendContinuationItemsAction"))][0]
           | .appendContinuationItemsAction.continuationItems) //
        ([.. | objects | select(has("richGridRenderer"))][0].richGridRenderer.contents) //
        [];

      items
      | map(select(has("richItemRenderer")) | .richItemRenderer.content.lockupViewModel)
      | map(select(. != null and (.contentId | test("^[A-Za-z0-9_-]{11}$"))))
      | map(
          [.metadata.lockupMetadataViewModel.metadata.contentMetadataViewModel.metadataRows[]?
            | .metadataParts[]?.text.content] as $parts
          | [ .contentId,
              ($parts[1] // ""),
              ([.contentImage.thumbnailViewModel.overlays[]?
                 | .thumbnailBottomOverlayViewModel.badges[0].thumbnailBadgeViewModel.text]
               | map(select(. != null)) | .[0] // ""),
              ($parts[0] // ""),
              (.metadata.lockupMetadataViewModel.title.content // "") ]
          | map(gsub("[\u0000\t\n]"; " ") | gsub("│"; "¦"))
          | join("\u001f"))
      | .[]
      JQ

      cat > "$tmp/token.jq" <<'JQ'
      ([.. | objects | select(has("appendContinuationItemsAction"))][0]
       | .appendContinuationItemsAction.continuationItems[]?
       | .continuationItemRenderer.continuationEndpoint.continuationCommand.token) //
      ([.. | objects | select(has("richGridRenderer"))][0].richGridRenderer.contents[]?
       | select(has("continuationItemRenderer"))
       | .continuationItemRenderer.continuationEndpoint.continuationCommand.token) //
      ""
      JQ

      jq -r -f "$tmp/rows.jq" "$tmp/page" > "$tmp/rows" 2>/dev/null || true
      jq -r -f "$tmp/token.jq" "$tmp/page" > "$state/token" 2>/dev/null || : > "$state/token"

      while IFS=$'\x1f' read -r id when dur views title; do
        [ -n "$id" ] || continue
        if grep -qxF "$id" "$state/ids" 2>/dev/null; then
          continue
        fi
        printf '%s\n' "$id" >> "$state/ids"
        meta=$views
        if [ -n "$dur" ]; then
          if [ -n "$meta" ]; then meta="$dur · $meta"; else meta=$dur; fi
        fi
        printf '%s│%-16s  %s\n   %s\0' "$id" "$when" "$title" "$meta" >> "$state/items"
      done < "$tmp/rows"

      cat "$state/items"
    '';
  };

  stats = pkgs.writeShellApplication {
    name = "ytc-stats";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      state=$1
      if [ -s "$state/notice" ]; then
        cat "$state/notice"
        : > "$state/notice"
      fi
      title=$(cat "$state/title" 2>/dev/null || true)
      [ -n "$title" ] || title='?'
      sort=$(cat "$state/sort" 2>/dev/null || echo latest)
      if [ "$sort" = popular ]; then ordre='plus populaires'; else ordre='plus récentes'; fi
      n=$(wc -l < "$state/ids" 2>/dev/null || echo 0)
      printf 'Chaîne : %s · %s vidéos · ordre : %s\n' "$title" "$n" "$ordre"
      printf 'Tab cocher · Entrée télécharger · Ctrl-N +30 · Ctrl-S ordre · Ctrl-O chaîne du flux · Ctrl-R autre chaîne\n'
    '';
  };

  pick = pkgs.writeShellApplication {
    name = "ytc-pick";
    runtimeInputs = with pkgs; [
      coreutils
      fzf
      gawk
    ];
    text = ''
      file=$1
      mapfile -t lines < <(
        awk '{ sub(/\r$/, "") }
             /^[[:space:]]*#/ { next }
             { gsub(/^[[:space:]]+/, ""); gsub(/[[:space:]]+$/, ""); if ($0 != "") print }' "$file" 2>/dev/null
      )
      if [ "''${#lines[@]}" -eq 0 ]; then
        echo "ytc: aucun canal dans $file" >&2
        exit 1
      fi
      printf '%s\n' "''${lines[@]}" | fzf --reverse --height=100% --prompt='chaîne> ' --print-query \
        --header="Chaînes de $file"$'\n'"Entrée : ouvrir la chaîne choisie · ou taper un nom, @handle, URL puis Entrée"
    '';
  };

  ytc = pkgs.writeShellApplication {
    name = "ytc";
    runtimeInputs = with pkgs; [
      coreutils
      fzf
      jq
      ytdlp
      youtubeApi
    ];
    text = ''
      usage() {
        cat <<'EOF'
      usage: ytc [-f FICHIER] [CHAÎNE]

        Parcourt les vidéos d'une chaîne YouTube dans fzf (vignette dans le
        volet de droite), les vidéos les plus récentes ou les plus populaires
        en premier, puis télécharge la sélection avec ytdl (voir ytdlp).

        CHAÎNE  nom de la chaîne (premier résultat de la recherche YouTube),
                @handle, URL de chaîne ou identifiant UC…
                Sans argument, la chaîne est choisie dans le fichier des
                chaînes de ytf.

        Tab     coche/décoche une vidéo ; Entrée télécharge la sélection
                (une seule vidéo si rien n'est coché), en 720p maximum, H.264
                30 fps. Régler YT_MAX_HEIGHT=480 pour alléger encore le
                décodage. La piste audio originale est toujours choisie
                (jamais un doublage automatique).
        Les cookies d'un navigateur connecté à YouTube sont passés à yt-dlp
        (voir ytdlp) : variables YT_COOKIES ou YT_COOKIES_FROM_BROWSER.
        Ctrl-N  charge 30 vidéos de plus.
        Ctrl-S  passe de l'ordre « plus récentes » à « plus populaires ».
        Ctrl-O  choisit une autre chaîne dans le fichier des chaînes de ytf.
        Ctrl-R  demande une autre chaîne (nom, @handle ou URL).

        -f FICHIER  fichier des chaînes, comme pour ytf
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
            echo "ytc: -$OPTARG attend un argument" >&2
            exit 2
            ;;
          *)
            usage >&2
            exit 2
            ;;
        esac
      done
      shift $((OPTIND - 1))
      channel="$*"

      # URL, @handle, /channel/ID ou UC… : résolution directe par YouTube ;
      # un nom ordinaire passe par la recherche, premier résultat
      resolve_cid() {
        input=$1
        case $input in
          http*) ;;
          *youtube.com/*|*youtu.be/*) input="https://$input" ;;
        esac
        case $input in
          http*|@*|/c/*|/user/*|/channel/*|UC[A-Za-z0-9_-]*)
            youtube-api resolve "$input" | head -n 1 | cut -d'│' -f2
            ;;
          *)
            youtube-api raw search \
              "$(jq -nc --arg q "$input" '{query: $q, params: "EgIQAg=="}')" \
              | jq -r '[.. | objects | select(has("channelRenderer"))][0].channelRenderer.channelId // empty'
            ;;
        esac
      }

      choose_channel() {
        local out=() sel
        mapfile -t out < <("${pick}/bin/ytc-pick" "$file" 2>/dev/null || true)
        sel=''${out[1]:-}
        [ -n "$sel" ] || sel=''${out[0]:-}
        printf '%s' "$sel"
      }

      state=$(mktemp -d)
      trap 'rm -rf "$state"' EXIT

      # $1 = chaîne demandée ; vide = choisir dans le fichier des chaînes
      open_channel() {
        local want=$1 cid
        while [ -z "$want" ]; do
          want=$(choose_channel)
          if [ -z "$want" ]; then
            printf 'Chaîne YouTube (nom, @handle ou URL) : '
            read -r want || exit 130
          fi
        done
        while :; do
          cid=$(resolve_cid "$want" || true)
          if [ -n "$cid" ] && [ "$cid" != '!' ]; then
            printf '%s\n' "$cid" > "$state/cid"
            printf '%s\n' latest > "$state/sort"
            : > "$state/title"
            return 0
          fi
          echo "ytc: chaîne introuvable : $want" >&2
          printf 'Chaîne YouTube (nom, @handle ou URL) : '
          read -r want || exit 130
        done
      }

      open_channel "$channel"

      while :; do
        if ! "${list}/bin/ytc-list" "$state" first > "$state/list"; then
          exit 1
        fi
        if [ ! -s "$state/list" ]; then
          echo "ytc: aucune vidéo publique sur cette chaîne" >&2
          exit 1
        fi

        mapfile -d "" -t picked < <(
          fzf --read0 --print0 --reverse --height=100% --prompt='ytc> ' \
            --expect=ctrl-r,ctrl-o --multi --marker='✔ ' --ellipsis='…' \
            --delimiter='│' --with-nth=2 --track --id-nth=1 \
            --header="$("${stats}/bin/ytc-stats" "$state")" \
            --bind "ctrl-n:reload-sync(${list}/bin/ytc-list $state next)+transform-header(${stats}/bin/ytc-stats $state)" \
            --bind "ctrl-s:reload-sync(${list}/bin/ytc-list $state flip)+transform-header(${stats}/bin/ytc-stats $state)" \
            --preview="${preview}/bin/ytc-preview {1}" \
            --preview-window='right,45%,border-left' \
            < "$state/list"
        )

        key="''${picked[0]:-}"
        case $key in
          ctrl-r)
            printf 'Chaîne YouTube (nom, @handle ou URL) : '
            next=""
            read -r next || exit 130
            [ -n "$next" ] || exit 130
            channel=$next
            ;;
          ctrl-o)
            channel=$(choose_channel)
            [ -n "$channel" ] || exit 130
            ;;
        esac
        if [ "$key" = ctrl-r ] || [ "$key" = ctrl-o ]; then
          open_channel "$channel"
          continue
        fi
        chosen=("''${picked[@]:1}")
        break
      done

      [ "''${#chosen[@]}" -gt 0 ] || exit 130

      urls=()
      for item in "''${chosen[@]}"; do
        urls+=("https://youtu.be/''${item%%│*}")
      done

      exec ytdl "''${urls[@]}"
    '';
  };
in
{
  home.packages = [ ytc ];
}
