set dotenv-load

default:
  just --list

update:
  nix flake update

test:
  @echo "Testing config for host $HOST"
  nh os test -H $HOST .

build:
  @echo "Building config for host $HOST"
  nh os build -H $HOST .

switch:
  @echo "Rebuilding config for host $HOST"
  nh os switch -H $HOST .

boot:
  @echo "Rebuilding config for host $HOST (available at next boot)"
  nh os boot -H $HOST .

rollback:
  @echo "Rolling back to previous generation"
  nh os rollback

install-proxmox-vm hostname ip:
  @echo "Installing {{hostname}} on {{ip}}"
  scp scripts/install-nixos.sh nixos@{{ip}}:/tmp/
  @echo "Script uploaded. Now SSH to the VM and run:"
  @echo "  ssh nixos@{{ip}}"
  @echo "  bash /tmp/install-nixos.sh {{hostname}}"

switch-proxmox-vm hostname ip:
  @echo "Deploying config for {{hostname}} to {{ip}}"
  nh os switch -H {{hostname}} . --target-host david@{{ip}}

boot-proxmox-vm hostname ip:
  @echo "Deploying config for {{hostname}} to {{ip}}"
  nh os boot -H {{hostname}} . --target-host david@{{ip}}

boot-all-proxmox-era-vms:
  @echo "Deploying config for all proxmox VMs on era host"
  just --justfile {{justfile()}} boot-proxmox-vm nixos-era-adguard adguard.home
  just --justfile {{justfile()}} boot-proxmox-vm nixos-era-nextcloud nextcloud.home
  just --justfile {{justfile()}} boot-proxmox-vm nixos-era-hermes hermes.home
  just --justfile {{justfile()}} boot-proxmox-vm nixos-era-nixflix nixflix.home
  just --justfile {{justfile()}} boot-proxmox-vm nixos-era-immich immich.home
  just --justfile {{justfile()}} boot-proxmox-vm nixos-era-navidrome navidrome.home
  just --justfile {{justfile()}} boot-proxmox-vm nixos-era-homelab homelab.home

clean-proxmox-vm hostname ip:
  @echo "Cleaning on {{hostname}} at {{ip}}"
  ssh david@{{ip}} "nh clean all --keep-since 7d --keep 5 && nix store gc"

clean:
  @echo "Cleaning old generations and garbage collecting"
  nh clean all --keep-since 7d --keep 5
  nix store gc

optimize:
  @echo "Cleaning and optimizing nix store"
  nh clean all --keep-since 7d --keep 5
  nix store gc
  nix store optimise

search query:
  @echo "Searching for packages: {{query}}"
  nh search {{query}}

info:
  @echo "Listing available generations"
  nh os info

first-install-disko host target:
  @echo "Installing host {{host}} on target disk {{target}}"
  sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake .#{{host}} --disk main {{target}} --show-trace

post-install-disko host target:
  @echo "Post-install setup for {{host}} on {{target}}"
  sudo bash scripts/post-install-disko.sh {{host}} {{target}} $USER

flake-linter:
	@echo "Running flake linter"
	nix run github:Mic92/flake-linter

nix-olde:
	@echo "Checking for outdated packages"
	nix run github:trofi/nix-olde -- -f . > $(date +%Y-%m-%d)_nix-olde-report.txt

# Secrets management with sops
secrets-edit file="secrets/secrets.yaml":
  @echo "Editing secrets (requires sops and age key)"
  SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops {{file}}

secrets-view file="secrets/secrets.yaml":
  @echo "Viewing decrypted secrets"
  SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops -d {{file}}

secrets-gen-key:
  @echo "Generating new age key"
  @echo "This will overwrite existing key at ~/.config/sops/age/keys.txt"
  @echo "Press Ctrl+C to cancel or Enter to continue..."
  @read _
  age-keygen -o ~/.config/sops/age/keys.txt
  @echo "New key generated. Public key:"
  @grep -o "age1[^ ]*" ~/.config/sops/age/keys.txt
  @echo "Update .sops.yaml with the new public key above"

secrets-test:
  @echo "Testing sops configuration for host $HOST"
  nixos-rebuild dry-activate --flake .#$HOST

all: update switch clean optimize
