set dotenv-load

default:
  just --list

switch:
  @echo "Rebuilding config for host $HOST"
  sudo nixos-rebuild switch --flake .#$HOST

clean:
  sudo nix-collect-garbage -d
  nix-collect-garbage -d

all: switch clean
