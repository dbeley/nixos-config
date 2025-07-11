set dotenv-load

default:
  just --list

update:
  nix flake update

switch:
  @echo "Rebuilding config for host $HOST"
  sudo nixos-rebuild switch --flake .#$HOST --max-jobs auto

boot:
  @echo "Rebuilding config for host $HOST (available at next boot)"
  sudo nixos-rebuild boot --flake .#$HOST

clean:
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
  # sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

optimize:
  nix-store --optimize -v

first-install-disko host target:
  @echo "Installing host {{host}} on target disk {{target}}"
  sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake .#{{host}} --disk main {{target}} --show-trace

all: update switch clean optimize

generate-image host format="install-iso":
  @echo "Generating $format image for host {{host}}"
  ./scripts/generate-image.sh {{host}} {{format}}
