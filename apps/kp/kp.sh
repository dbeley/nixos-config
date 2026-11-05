# shellcheck shell=bash
# tofi + keepassxc-cli front-end for the pocket vault. Read-only: this script
# only ever calls `ls`/`show`, never `add`/`edit`/`rm`.
#
# The database path is substituted at build time by package.nix.

db="@database@"

die() { notify-send -u critical "kp" "$1"; exit 1; }

copy() {
  local secs="${KP_CLEAR_SECS:-45}"
  printf '%s' "$1" | wl-copy
  ( sleep "$secs"; wl-copy --clear ) &
  disown
  notify-send -t 3000 "kp" "$2 — clears in ${secs}s"
}

[ -r "$db" ] || die "database not found: $db"

# Masked master password prompt. With no candidate entries to match,
# --require-match=false makes Enter print whatever was typed.
master=$(tofi --prompt-text="Master password: " \
  --hide-input=true --hidden-character="*" --require-match=false < /dev/null) || exit 0
[ -n "$master" ] || exit 0

# `keepassxc-cli ls -R` prints groups with a trailing "/", children indented two
# spaces per level, and a localized "[empty]"/"[vide]" placeholder for groups
# with no entries. Rebuild full entry paths from that indentation.
paths=$(printf '%s\n' "$master" | keepassxc-cli ls -R "$db" 2>/dev/null | awk -f "@awk@") ||
  die "could not unlock the database"
[ -n "$paths" ] || die "no entries found"

entry=$(printf '%s\n' "$paths" | tofi --prompt-text="kp: ") || exit 0
[ -n "$entry" ] || exit 0

value=$(printf '%s' "$master" | keepassxc-cli show -q -a Password "$db" "$entry") ||
  die "could not read the entry"
[ -n "$value" ] || die "empty password for $entry"

copy "$value" "$entry"
