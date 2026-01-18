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

install-proxmox-vm-local hostname ip:
  @echo "Installing {{hostname}} on {{ip}} (local network)"
  scp scripts/install-nixos.sh nixos@{{ip}}:/tmp/
  @echo "Script uploaded. Now SSH to the VM and run:"
  @echo "  ssh nixos@{{ip}}"
  @echo "  bash /tmp/install-nixos.sh {{hostname}}"

switch-proxmox-vm-local hostname ip:
  @echo "Deploying config for {{hostname}} to {{ip}} (local network)"
  nixos-rebuild switch --flake .#{{hostname}} --target-host root@{{ip}} --sudo

install-proxmox-vm-kimsufi hostname ip:
  @echo "Installing {{hostname}} on {{ip}} via kimsufi jump host"
  scp -J kimsufi scripts/install-nixos.sh nixos@{{ip}}:/tmp/
  @echo "Script uploaded. Now SSH to the VM and run:"
  @echo "  ssh -J kimsufi nixos@{{ip}}"
  @echo "  bash /tmp/install-nixos.sh {{hostname}}"

switch-proxmox-vm-kimsufi hostname ip:
  @echo "Deploying config for {{hostname}} to {{ip}} via kimsufi jump host"
  NIX_SSHOPTS="-J kimsufi" nixos-rebuild switch --flake .#{{hostname}} --target-host {{ip}} --sudo --ask-sudo-password

clean:
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
  # sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

optimize:
  nix-store --optimize -v

build-iso:
  @echo "Building generic installer ISO"
  nix build .#iso-installer --print-out-paths

build-proxmox host:
  @echo "Building Proxmox image for {{host}}"
  nix build .#proxmox-{{host}} --print-out-paths

first-install-disko host target:
  @echo "Installing host {{host}} on target disk {{target}}"
  sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake .#{{host}} --disk main {{target}} --show-trace

all: update switch clean optimize
