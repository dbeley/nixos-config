#!/usr/bin/env bash
set -eEu -o pipefail
TODAY="$(date +%Y-%m-%d)"
HOSTNAME="$(cat /proc/sys/kernel/hostname)"
DESTINATION_DIR="$HOME/Nextcloud/10-19_Images/11_Captures-d-écran/11.01_autoscreen/$TODAY"

mkdir -p "$DESTINATION_DIR"
grim "${DESTINATION_DIR}/${HOSTNAME}_autoscreen_$(date +%Y-%m-%d_%H:%M:%S_%s).png"
