#!/usr/bin/env bash
# Post-installation setup for disko/impermanence hosts
# Mounts the newly installed system and creates the mandatory password file
# Usage: post-install-disko.sh <hostname> <disk-device> [user]
# Example: post-install-disko.sh x1yoga /dev/sda david

set -e

HOST=${1:?Usage: $0 <hostname> <disk-device> [user]}
DISK=${2:?Usage: $0 <hostname> <disk-device> [user]}
USER_NAME=${3:-david}

# Detect partition suffix: nvme/mmcblk use pN, others use N
case "$DISK" in
  /dev/nvme*|/dev/mmcblk*) PART="${DISK}p" ;;
  *) PART="${DISK}" ;;
esac

LUKS_NAME="root_vg_${HOST}"
MNT="/mnt/root"

echo "Opening LUKS partition ${PART}2 as ${LUKS_NAME}"
sudo cryptsetup open "${PART}2" "$LUKS_NAME"

echo "Mounting subvolumes at ${MNT}"
sudo mkdir -p "$MNT"
sudo mount -o subvol=root,compress=zstd,noatime "/dev/mapper/${LUKS_NAME}" "$MNT"
sudo mkdir -p "$MNT/persistent" "$MNT/nix" "$MNT/boot"
sudo mount -o subvol=persistent,compress=zstd,noatime "/dev/mapper/${LUKS_NAME}" "$MNT/persistent"
sudo mount -o subvol=nix,compress=zstd,noatime "/dev/mapper/${LUKS_NAME}" "$MNT/nix"
sudo mount "${PART}1" "$MNT/boot"

echo "Creating password file for ${USER_NAME} (MANDATORY for impermanence)"
mkpasswd > "/tmp/passwd_${USER_NAME}"
sudo mv "/tmp/passwd_${USER_NAME}" "$MNT/persistent/passwd_${USER_NAME}"
sudo chown root:root "$MNT/persistent/passwd_${USER_NAME}"
sudo chmod 600 "$MNT/persistent/passwd_${USER_NAME}"

echo ""
echo "Done. To chroot into the new system:"
echo "  sudo nixos-enter --root $MNT"
