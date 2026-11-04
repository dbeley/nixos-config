#!/usr/bin/env bash
# Install NixOS on the MNT Pocket Reform i.MX8MP.
#
# Layout (unencrypted, mutable):
#   microSD p1 1 GiB ext4 NIXOS_BOOT  -> /boot
#   microSD p2 rest        ext4 NIXOS_DATA -> spare/backups (optional)
#   NVMe p1 100%           ext4        -> /
#
# There is no LUKS: the initrd never asks for a passphrase, which avoids the
# unusable internal keyboard in the initrd. There is no impermanence: /etc,
# /var and /home persist on the root filesystem.
#
# The eMMC Debian installation and its U-Boot (mmcblk2boot0) are untouched.
#
# Run as the normal user (not root), interactively, from the root of the
# nixos-config checkout:
#   ./scripts/install-pocket.sh
#
# The SD/NVMe device names can be overridden, but the NVMe must match
# disko.mainDisk from the flake (the script refuses a mismatch).
set -euo pipefail

HOST="${HOST:-pocket-reform}"
NIX="${NIX:-/nix/var/nix/profiles/default/bin/nix}"
SD="${SD:-/dev/mmcblk0}"
NVME_OVERRIDE="${NVME:-}"
FLAKE="path:$PWD"
HOST_FLAKE="${FLAKE}#${HOST}"
NIXOS_FLAKE="${FLAKE}#nixosConfigurations.${HOST}"
export NIX_CONFIG="experimental-features = nix-command flakes"

if [ "$(id -u)" -eq 0 ]; then
  echo "Run this script as your normal user; it uses sudo internally." >&2
  exit 1
fi

if [ ! -t 0 ]; then
  echo "Run this script interactively: it prompts for the user password." >&2
  exit 1
fi

if [ ! -f "$PWD/flake.nix" ] || [ ! -d "$PWD/hosts/${HOST}" ]; then
  echo "Run this script from the nixos-config checkout (flake.nix + hosts/${HOST})." >&2
  exit 1
fi

part() {
  case "$1" in
    *[0-9]) printf '%sp%s' "$1" "$2" ;;
    *) printf '%s%s' "$1" "$2" ;;
  esac
}

run_sudo() {
  # /usr/sbin and /sbin are needed for chroot (nixos-enter), mount, etc.
  sudo env PATH="$PATH:/usr/sbin:/sbin" "$@"
}

# The NVMe (the disko target) will be wiped. The Nix daemon's build
# directory must live on a persistent disk, otherwise `nix run disko` and
# `nixos-install` fail after disko unmounts the old NVMe filesystem.
# Use /var/lib, not /var/tmp: Nix refuses a build-dir whose parents are
# world-writable (and /var/tmp is 1777).
BUILD_DIR="/var/lib/nix-build"
echo "==> Ensuring a persistent Nix build directory (${BUILD_DIR})"
run_sudo mkdir -p "$BUILD_DIR"
# Nix refuses a world-writable or symlinked build-dir. The nixbld group
# needs write access; 0775 is not world-writable.
run_sudo chown root:nixbld "$BUILD_DIR"
run_sudo chmod 0775 "$BUILD_DIR"
if ! grep -q "^build-dir = ${BUILD_DIR}$" /etc/nix/nix.conf 2>/dev/null; then
  run_sudo sed -i '/^build-dir/d' /etc/nix/nix.conf 2>/dev/null || true
  echo "build-dir = ${BUILD_DIR}" | run_sudo tee -a /etc/nix/nix.conf >/dev/null
fi
run_sudo systemctl restart nix-daemon.service

echo "==> Reading the target NVMe from the flake"
FLAKE_NVME="$("$NIX" eval --raw "${NIXOS_FLAKE}.config.disko.mainDisk")"
if [ -n "$NVME_OVERRIDE" ] && [ "$NVME_OVERRIDE" != "$FLAKE_NVME" ]; then
  echo "NVME=$NVME_OVERRIDE does not match disko.mainDisk=$FLAKE_NVME" >&2
  exit 1
fi
NVME="$FLAKE_NVME"

[ -b "$SD" ] || { echo "Not a block device: $SD" >&2; exit 1; }
[ -b "$NVME" ] || { echo "Not a block device: $NVME" >&2; exit 1; }
[ "$SD" != "$NVME" ] || { echo "SD and NVMe are the same device" >&2; exit 1; }
case "$SD" in
  /dev/mmcblk2*)
    echo "Refusing to use the eMMC ($SD) as the microSD target" >&2
    exit 1
    ;;
esac

echo "==> Fetching required tools from the pinned nixpkgs"
TOOL_PATHS="$("$NIX" build --no-link --print-out-paths --inputs-from "$PWD" \
  nixpkgs#parted nixpkgs#cryptsetup nixpkgs#openssl nixpkgs#util-linux nixpkgs#e2fsprogs)"
while IFS= read -r tool_path; do
  PATH="$tool_path/bin:$PATH"
done <<< "$TOOL_PATHS"
export PATH

for tool in parted cryptsetup openssl wipefs mkfs.ext4 lsblk mount umount; do
  command -v "$tool" >/dev/null || {
    echo "Missing tool after fetching: $tool" >&2
    exit 1
  }
done

echo "==> Building the NixOS closure (before any destructive step)"
TMPDIR="${TMPDIR:-/var/tmp}"
export TMPDIR
AVAIL_KB="$(df -Pk "$TMPDIR" | awk 'NR==2 {print $4}')"
if [ "${AVAIL_KB:-0}" -lt 20971520 ]; then
  echo "Warning: less than 20 GiB free in TMPDIR=$TMPDIR" >&2
  echo "         Set TMPDIR to a large directory before running this script." >&2
fi
SYSTEM_PATH="$("$NIX" build --no-link --print-out-paths "${NIXOS_FLAKE}.config.system.build.toplevel")"
[ -n "$SYSTEM_PATH" ] || { echo "Failed to build the NixOS closure" >&2; exit 1; }
echo "    Closure: $SYSTEM_PATH"

echo "==> Password for user david"
echo "    This password is set after nixos-install (mutable users)."
read -r -s -p "Password: " PASSWORD
echo
read -r -s -p "Confirm : " PASSWORD_CONFIRM
echo
[ -n "$PASSWORD" ] || { echo "Empty password; aborting." >&2; exit 1; }
[ "$PASSWORD" = "$PASSWORD_CONFIRM" ] || { echo "Passwords do not match; aborting." >&2; exit 1; }
HASH="$(printf '%s\n' "$PASSWORD" | openssl passwd -6 -stdin)"
unset PASSWORD PASSWORD_CONFIRM
case "$HASH" in
  \$6\$*) ;;
  *)
    echo "Invalid password hash generated; aborting." >&2
    exit 1
    ;;
esac

echo
echo "This will ERASE:"
echo "  microSD : $SD  (p1 NIXOS_BOOT, p2 NIXOS_DATA)"
echo "  NVMe    : $NVME (ext4 root, NO encryption)"
echo
lsblk -o NAME,SIZE,MODEL,MOUNTPOINTS "$SD" "$NVME"
echo
read -r -p "Type ERASE to continue: " answer
[ "$answer" = "ERASE" ] || { echo "Aborted."; exit 1; }

echo "==> Disabling swap on the target devices"
while read -r swap_dev _; do
  case "$swap_dev" in
    "$SD"* | "$NVME"*) run_sudo swapoff "$swap_dev" || true ;;
  esac
done < <(awk 'NR>1 {print $1}' /proc/swaps)

echo "==> Unmounting existing filesystems"
run_sudo umount -R /mnt 2>/dev/null || true
run_sudo umount -R /mnt/sdboot 2>/dev/null || true
run_sudo umount "$(part "$SD" 1)" "$(part "$SD" 2)" "$(part "$NVME" 1)" 2>/dev/null || true

# Only needed if an earlier LUKS install left its mapper open.
echo "==> Closing any stale LUKS mapper from an earlier install"
run_sudo cryptsetup close "root_vg_${HOST}" 2>/dev/null || true

echo "==> Partitioning microSD"
run_sudo wipefs -a "$SD"
run_sudo parted -s "$SD" mklabel gpt
run_sudo parted -s "$SD" mkpart boot ext4 1MiB 1GiB
run_sudo parted -s "$SD" mkpart data ext4 1GiB 100%
run_sudo mkfs.ext4 -F -L NIXOS_BOOT "$(part "$SD" 1)"
run_sudo mkfs.ext4 -F -L NIXOS_DATA "$(part "$SD" 2)"
run_sudo udevadm settle 2>/dev/null || sleep 2

echo "==> Partitioning and formatting the NVMe with disko (ext4, no LUKS)"
run_sudo env NIX_CONFIG="$NIX_CONFIG" \
  "$NIX" run github:nix-community/disko -- --mode disko --flake "$HOST_FLAKE"

echo "==> Mounting microSD /boot"
run_sudo mkdir -p /mnt/boot
run_sudo mount "$(part "$SD" 1)" /mnt/boot

echo "==> Installing NixOS"
INSTALL_TOOLS="$("$NIX" build --no-link --print-out-paths --inputs-from "$PWD" \
  nixpkgs#nixos-install-tools)"
# No runtime host path is referenced: the LUKS key is gone, so the flake
# evaluates purely without --impure.
run_sudo env NIX_CONFIG="$NIX_CONFIG" \
  "$INSTALL_TOOLS/bin/nixos-install" --flake "$HOST_FLAKE" --no-root-passwd

echo "==> Setting the password for user david"
CHPASSWD="$(readlink -f "$SYSTEM_PATH/sw/bin/chpasswd")"
if ! printf 'david:%s\n' "$HASH" | run_sudo env NIX_CONFIG="$NIX_CONFIG" \
  "$INSTALL_TOOLS/bin/nixos-enter" --root /mnt -c "$CHPASSWD -e"; then
  echo "    nixos-enter failed; falling back to a direct chroot" >&2
  printf 'david:%s\n' "$HASH" | run_sudo chroot /mnt "$CHPASSWD" -e
fi

echo "==> Copying existing NetworkManager profiles for first-boot networking"
run_sudo mkdir -p /mnt/etc/NetworkManager/system-connections
if compgen -G "/etc/NetworkManager/system-connections/*.nmconnection" >/dev/null; then
  run_sudo cp /etc/NetworkManager/system-connections/*.nmconnection \
    /mnt/etc/NetworkManager/system-connections/
  run_sudo chmod 600 /mnt/etc/NetworkManager/system-connections/*.nmconnection
fi

echo "==> Unmounting"
run_sudo umount -R /mnt

cat <<'EOF'

Installation complete.

Boot layout:
  microSD p1  ext4 NIXOS_BOOT -> /boot
  NVMe p1     ext4            -> /   (no LUKS)
  eMMC        Debian + U-Boot untouched

Next steps:
  1. Reboot with the microSD inserted. U-Boot scans the microSD before the
     eMMC, so NixOS should boot. Remove the microSD to boot Debian instead.
     There is no LUKS passphrase prompt: the initrd mounts the ext4 root
     directly.
  2. Log in as david with the password set above. SSH should also work with
     your GitHub keys once Wi-Fi is up.
  3. The system is mutable: /etc, /var and /home persist across reboots.
     There is no impermanence cleanup.
  4. Clone the repo on the device and install the same generation so the
     bootloader hook refreshes boot.scr/kernel/initrd/DTB:
       git clone https://github.com/dbeley/nixos-config.git
       cd nixos-config
       git checkout pocket-reform
       echo 'HOST=pocket-reform' > .env
       just boot
       sudo reboot

If the screen stays black, SSH in and inspect:
  dmesg | grep -iE 'drm|panel|dsi|lcdif|backlight'
  ls /sys/class/backlight
  cat /sys/class/backlight/*/brightness

If the SD card is lost or replaced, only /boot and boot.scr are affected:
the NVMe root is unencrypted and can be mounted from Debian or a rescue
system.
EOF
