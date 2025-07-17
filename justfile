set dotenv-load

default:
  just --list

update:
  nix flake update

switch:
  @echo "Rebuilding config for host $HOST"
  sudo nixos-rebuild switch --flake .#$HOST --max-jobs auto

switch-remote-host host target:
  @echo "Rebuilding config for host {{host}} on target {{target}}"
  sudo -E nixos-rebuild switch --flake .#{{host}} --target-host $USER@{{target}} --sudo --ask-sudo-password

boot:
  @echo "Rebuilding config for host $HOST (available at next boot)"
  sudo nixos-rebuild boot --flake .#$HOST

boot-remote-host host target:
  @echo "Rebuilding config for host {{host}} on target {{target}}"
  sudo -E nixos-rebuild boot --flake .#{{host}} --target-host $USER@{{target}} --sudo --ask-sudo-password

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
