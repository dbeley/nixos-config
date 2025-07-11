#!/usr/bin/env bash
# Generate a NixOS image using nixos-generators
# Usage: ./scripts/generate-image.sh <host> [format]

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <host> [format]" >&2
  exit 1
fi

HOST="$1"
FORMAT="${2:-install-iso}"

exec nix run github:nix-community/nixos-generators -- --flake ".#$HOST" -f "$FORMAT"
