#!/usr/bin/env bash
# NixOS Installation Script for Proxmox VMs
# Copy this to the VM and run: bash install-nixos.sh
# Usage: bash install-nixos.sh [hostname]
# Example: bash install-nixos.sh nixos-kimsufi-01

set -e

HOSTNAME=${1:-}
DISK=${2:-/dev/sda}

if [ -z "$HOSTNAME" ]; then
    echo "Usage: bash install-nixos.sh <hostname> [disk]"
    exit 1
fi

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
sudo mkfs.ext4 -L boot "${DISK}2"
sudo mkfs.ext4 -L nixos "${DISK}3"
sudo mkswap -L swap "${DISK}4"
echo "✓ Partitions formatted"

# Wait for kernel to update device symlinks
sudo partprobe "$DISK"
sleep 2
sudo udevadm settle

echo ""
echo "[3/8] Mounting filesystems..."
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo swapon "${DISK}4"
echo "✓ Filesystems mounted"

echo ""
echo "[4/8] Generating NixOS configuration..."
sudo nixos-generate-config --root /mnt
echo "✓ Configuration generated"

echo ""
echo "[5/8] Getting UUID..."
UUID=$(sudo blkid "${DISK}3" -s UUID -o value)
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
sudo tee /mnt/etc/nixos/configuration.nix > /dev/null << 'EOF'
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "nixos-temp";
    useDHCP = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  users.users.root.initialPassword = "nixos";

  users.users.david = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keyFiles = [
      (pkgs.fetchurl {
        url = "https://github.com/dbeley.keys";
        sha256 = "m3UIHF7Vp6Tut5RAgXcZ9+gnu6V0a/2doEVpIOij+kw=";
      })
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [ vim git btop ];

  system.stateVersion = "25.11";
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
echo "1. On your LOCAL machine, edit:"
echo "     hosts/$HOSTNAME/hardware-configuration.nix"
echo "   Replace PLACEHOLDER with: $UUID"
echo ""
echo "2. Reboot this VM"
echo ""
echo "3. After reboot, deploy final config from local machine:"
echo "     sudo nixos-rebuild switch --flake .#$HOSTNAME --target-host root@<IP>"
echo ""
echo "=========================================="
echo ""
read -r -p "Press Enter to reboot now, or Ctrl+C to cancel: "
sudo reboot
