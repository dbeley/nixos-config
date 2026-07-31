#!/usr/bin/env bash
# NixOS Installation Script for Proxmox VMs
# Copy this to the VM and run: bash install-nixos.sh
# Usage: bash install-nixos.sh [hostname]
# Example: bash install-nixos.sh nixos-kimsufi-01

set -euo pipefail

HOSTNAME=${1:-}
DISK=${2:-/dev/sda}
STATE_VERSION=${3:-26.05}

if [ -z "$HOSTNAME" ]; then
    echo "Usage: bash install-nixos.sh <hostname> [disk] [state-version]"
    exit 1
fi

# Detect partition suffix: nvme/mmcblk use pN, others use N
case "$DISK" in
  /dev/nvme*|/dev/mmcblk*) PART="${DISK}p" ;;
  *) PART="${DISK}" ;;
esac

echo "============================================"
echo "NixOS Installation for $HOSTNAME"
echo "Disk: $DISK"
echo "============================================"
echo ""
read -r -p "This will ERASE ALL DATA on $DISK. Type 'yes' to continue: " confirm
if [ "$confirm" != "yes" ]; then
    echo "Installation cancelled."
    exit 1
fi

echo ""
echo "[1/8] Partitioning disk..."
sudo parted "$DISK" -- mklabel gpt
sudo parted "$DISK" -- mkpart primary 1MB 2MB
sudo parted "$DISK" -- set 1 bios_grub on
sudo parted "$DISK" -- mkpart primary 2MB 512MB
sudo parted "$DISK" -- mkpart primary 512MB -8GB
sudo parted "$DISK" -- mkpart primary linux-swap -8GB 100%
echo "✓ Disk partitioned"

echo ""
echo "[2/8] Formatting partitions..."
# Partition 1 is BIOS boot (no filesystem)
sudo partprobe "$DISK"
sudo udevadm settle
sudo mkfs.ext4 -L boot "${PART}2"
sudo mkfs.ext4 -L nixos "${PART}3"
sudo mkswap -L swap "${PART}4"
echo "✓ Partitions formatted"

echo ""
echo "[3/8] Mounting filesystems..."
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo swapon "${PART}4"
echo "✓ Filesystems mounted"

echo ""
echo "[4/8] Generating NixOS configuration..."
sudo nixos-generate-config --root /mnt
echo "✓ Configuration generated"

echo ""
echo "[5/8] Getting UUID..."
UUID=$(sudo blkid "${PART}3" -s UUID -o value)
echo "=========================================="
echo "IMPORTANT: SAVE THIS UUID!"
echo ""
echo "Hostname: $HOSTNAME"
echo "UUID: $UUID"
echo ""
echo "You need to update this in:"
echo "  hosts/$HOSTNAME/hardware-configuration.nix"
echo "=========================================="
echo ""
read -r -p "Press Enter after you've saved the UUID..."

echo ""
echo "[6/8] Creating minimal configuration..."
sudo tee /mnt/etc/nixos/configuration.nix > /dev/null << EOF
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    device = "$DISK";
  };

  networking = {
    hostName = "nixos-temp";
    useDHCP = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  users.users.david = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" "networkmanager"];
  };
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [
        "root"
        "david"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "$STATE_VERSION";
}
EOF
echo "✓ Configuration created"

echo ""
echo "[7/8] Installing NixOS (this will take 5-10 minutes)..."
sudo nixos-install --root /mnt --no-root-passwd
echo "✓ NixOS installed"

echo ""
echo "[8/8] Installation complete!"
echo ""
echo "=========================================="
echo "Summary"
echo "=========================================="
echo "Hostname: $HOSTNAME (temporary, will change on final deployment)"
echo "UUID: $UUID"
echo ""
echo "NEXT STEPS:"
echo "1. If you haven't done so already on step 5:"
echo "   On your LOCAL machine, edit:"
echo "     hosts/$HOSTNAME/hardware-configuration.nix"
echo "   Replace PLACEHOLDER with: $UUID"
echo ""
echo "2. Reboot this VM"
echo ""
echo "3. After reboot, deploy final config from your local machine"
echo "   (initial password for david: nixos):"
echo "     just boot-proxmox-vm $HOSTNAME <IP>"
echo ""
echo "4. After first login as david, CHANGE the password:"
echo "     passwd"
echo ""
echo "=========================================="
echo ""
read -r -p "Press Enter to reboot now, or Ctrl+C to cancel: "
sudo reboot
