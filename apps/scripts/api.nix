{
  coreutils,
  curl,
  gawk,
  writeShellApplication,
}:
writeShellApplication {
  name = "youtube-api";
  runtimeInputs = [
    coreutils
    curl
    gawk
  ];
  text = ''
    cache="''${XDG_CACHE_HOME:-$HOME/.cache}/youtube-api"
    mkdir -p "$cache/meta" "$cache/resolve"
    max_age=604800

    client() {
      local f="$cache/client" page key ver mtime
      mtime=$(stat -c %Y "$f" 2>/dev/null) || mtime=0
      if [ "$mtime" -gt 0 ] && [ "$(( $(date +%s) - mtime ))" -lt "$max_age" ]; then
        { read -r KEY; read -r VER; } < "$f" 2>/dev/null || true
        if [ -n "''${KEY:-}" ] && [ -n "''${VER:-}" ]; then
          return 0
        fi
      fi
      page=$(curl -fsSL -m 15 'https://www.youtube.com/' 2>/dev/null) || page=""
      key=$(printf '%s' "$page" | grep -o '"INNERTUBE_API_KEY":"[^"]*"' | head -1 | cut -d'"' -f4) || key=""
      ver=$(printf '%s' "$page" | grep -o '"INNERTUBE_CLIENT_VERSION":"[^"]*"' | head -1 | cut -d'"' -f4) || ver=""
      if [ -z "$key" ] || [ -z "$ver" ]; then
        return 1
      fi
      printf '%s\n%s\n' "$key" "$ver" > "$f"
      KEY=$key
      VER=$ver
    }

    api() { # $1 = method, $2 = json payload fragment; prints the json body
      local method=$1 payload=$2 url body raw code hl gl
      hl=''${YT_HL:-en}
      gl=''${YT_GL:-US}
      client || return 1
      url="https://www.youtube.com/youtubei/v1/$method?key=$KEY&prettyPrint=false"
      body="{\"context\":{\"client\":{\"clientName\":\"WEB\",\"clientVersion\":\"$VER\",\"hl\":\"$hl\",\"gl\":\"$gl\"}},$payload}"
      raw=$(curl -sS -m 10 -w '\n%{http_code}' -X POST "$url" -H 'Content-Type: application/json' \
        -d "$body" 2>/dev/null) || raw=""
      code="''${raw##*$'\n'}"
      if [ "$code" = 400 ] || [ "$code" = 403 ]; then
        # key or client version went stale: refresh once and retry
        rm -f "$cache/client"
        client || return 1
        url="https://www.youtube.com/youtubei/v1/$method?key=$KEY&prettyPrint=false"
        body="{\"context\":{\"client\":{\"clientName\":\"WEB\",\"clientVersion\":\"$VER\",\"hl\":\"$hl\",\"gl\":\"$gl\"}},$payload}"
        raw=$(curl -sS -m 10 -w '\n%{http_code}' -X POST "$url" -H 'Content-Type: application/json' \
          -d "$body" 2>/dev/null) || raw=""
        code="''${raw##*$'\n'}"
      fi
      if [ "$code" != 200 ]; then
        return 1
      fi
      printf '%s' "''${raw%$'\n'*}"
    }

    # upload date + duration of one video, cached (neither ever changes)
    meta_one() {
      local id=$1 f="$cache/meta/$1" resp iso dur
      if [ -s "$f" ]; then
        return 0
      fi
      resp=$(api player "\"videoId\":\"$id\"") || return 0
      iso=$(printf '%s' "$resp" | grep -o '"uploadDate":"[^"]*"' | head -1 | cut -d'"' -f4) || iso=""
      dur=$(printf '%s' "$resp" | grep -o '"lengthSeconds":"[0-9]*"' | head -1 | tr -dc '0-9') || dur=""
      if [ -z "$iso" ]; then
        return 0
      fi
      printf '%s│%s\n' "$(date -d "$iso" '+%Y-%m-%d %H:%M')" "$dur" > "$f"
    }

    slug() { printf '%s' "$1" | tr -c 'A-Za-z0-9._-' '_'; }

    # @handle, /c/, /user/, /channel/ URL or bare UC id -> channel id, cached
    resolve_one() {
      local input=$1 url f resp id
      case $input in
        UC[A-Za-z0-9_-]*) return 0 ;;
        http*) url=$input ;;
        *) url="https://www.youtube.com/$input" ;;
      esac
      f="$cache/resolve/$(slug "$input")"
      if [ -s "$f" ]; then
        return 0
      fi
      resp=$(api navigation/resolve_url "\"url\":\"$url\"") || resp=""
      id=$(printf '%s' "$resp" | grep -o '"browseId":"UC[A-Za-z0-9_-]\{22\}"' | head -1 | cut -d'"' -f4) || id=""
      if [ -z "$id" ]; then
        # fallback: the channel page itself (1.6 MB, only for pages the API rejects)
        id=$(curl -fsSL -m 15 "$url" 2>/dev/null | grep -o '"externalId":"UC[A-Za-z0-9_-]\{22\}"' \
          | head -1 | cut -d'"' -f4) || id=""
      fi
      if [ -n "$id" ]; then
        printf '%s\n' "$id" > "$f"
      else
        printf '!\n' > "$f"
      fi
    }

    batch() { # $1 = function name, rest = arguments, 12 at a time
      local fn=$1 max=12
      shift
      for a in "$@"; do
        "$fn" "$a" &
        while [ "$(jobs -rp | wc -l)" -ge "$max" ]; do
          wait -n || true
        done
      done
      wait || true
    }

    cmd=$1
    shift
    case $cmd in
      meta)
        client || exit 1
        batch meta_one "$@"
        for id in "$@"; do
          if [ -s "$cache/meta/$id" ]; then
            printf '%s│%s\n' "$id" "$(cat "$cache/meta/$id")"
          fi
        done
        ;;
      resolve)
        need_api=0
        for input in "$@"; do
          case $input in
            UC[A-Za-z0-9_-]*) ;;
            *) need_api=1 ;;
          esac
        done
        if [ "$need_api" -eq 1 ]; then
          client || exit 1
        fi
        batch resolve_one "$@"
        for input in "$@"; do
          case $input in
            UC[A-Za-z0-9_-]*) printf '%s│%s\n' "$input" "$input"; continue ;;
          esac
          f="$cache/resolve/$(slug "$input")"
          if [ -s "$f" ] && [ "$(cat "$f")" != '!' ]; then
            printf '%s│%s\n' "$input" "$(cat "$f")"
          else
            printf '%s│!\n' "$input"
          fi
        done
        ;;
      raw) # $1 = youtubei method, $2 = json payload object (outer braces optional)
        if [ $# -lt 2 ]; then
          echo "usage: youtube-api raw METHOD JSON" >&2
          exit 2
        fi
        payload=$2
        payload=''${payload#\{}
        payload=''${payload%\}}
        api "$1" "$payload" || exit 1
        ;;
      *)
        echo "usage: youtube-api meta ID... | resolve URL|@handle|/channel/ID | raw METHOD JSON" >&2
        exit 2
        ;;
    esac
  '';
}
