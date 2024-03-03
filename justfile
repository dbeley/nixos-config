set dotenv-load

default:
  just --list

update:
  nix flake update

switch:
  @echo "Rebuilding config for host $HOST"
  sudo nixos-rebuild switch --flake .#$HOST

clean:
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
  # sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

optimize:
  nix-store --optimize -v

all: update switch clean optimize
