# shellcheck shell=bash
# tofi + keepassxc-cli front-end for the pocket vault. Read-only: this script
# only ever calls `ls`/`show`, never `add`/`edit`/`rm`.
#
# The database path is substituted at build time by package.nix.

db="@database@"
mode=password
[ "${1:-}" = "--actions" ] && mode=actions

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

field=Password
label=Password
if [ "$mode" = actions ]; then
  action=$(printf '%s\n' Password Username TOTP URL "Open KeePassXC" | tofi --prompt-text="Action: ") || exit 0
  case "$action" in
    Password) field=Password; label=Password ;;
    Username) field=UserName; label=Username ;;
    URL) field=URL; label=URL ;;
    TOTP) field=--totp; label=TOTP ;;
    "Open KeePassXC")
      # Escape hatch: the GUI, for editing entries and chromium autofill.
      keepassxc "$db" >/dev/null 2>&1 &
      disown
      exit 0
      ;;
    *) exit 0 ;;
  esac
fi

if [ "$field" = --totp ]; then
  value=$(printf '%s' "$master" | keepassxc-cli show -q --totp "$db" "$entry") ||
    die "no TOTP configured for $entry"
else
  value=$(printf '%s' "$master" | keepassxc-cli show -q -a "$field" "$db" "$entry") ||
    die "could not read the entry"
fi
[ -n "$value" ] || die "no $label for $entry"

copy "$value" "$entry · $label"
