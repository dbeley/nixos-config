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

build-iso-image:
  @echo "Building generic installer ISO"
  nix build .#iso-installer --print-out-paths

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

flake-linter:
	@echo "Running flake linter"
	nix run github:Mic92/flake-linter

nix-olde:
	@echo "Checking for outdated packages"
	nix run github:trofi/nix-olde -- -f . > $(date +%Y-%m-%d)_nix-olde-report.txt

# Secrets management with sops
secrets-edit:
    @echo "Editing secrets (requires sops and age key)"
    SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops secrets/secrets.yaml

secrets-view:
    @echo "Viewing decrypted secrets"
    SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops -d secrets/secrets.yaml

secrets-set key value:
    @echo "Setting secret: {{key}} = {{value}}"
    SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --set '{{key}} "{{value}}"' secrets/secrets.yaml

secrets-get key:
    @echo "Getting secret: {{key}}"
    SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --extract '{{key}}' -d secrets/secrets.yaml

secrets-gen-key:
    @echo "Generating new age key"
    @echo "This will overwrite existing key at ~/.config/sops/age/keys.txt"
    @echo "Press Ctrl+C to cancel or Enter to continue..."
    @read _
    age-keygen -o ~/.config/sops/age/keys.txt
    @echo "New key generated. Public key:"
    @grep -o "age1[^ ]*" ~/.config/sops/age/keys.txt
    @echo "Update .sops.yaml with the new public key above"

secrets-show-key:
    @echo "Age public key:"
    @grep -o "age1[^ ]*" ~/.config/sops/age/keys.txt 2>/dev/null || echo "No age key found at ~/.config/sops/age/keys.txt"

secrets-test:
    @echo "Testing sops configuration for host $HOST"
    nixos-rebuild dry-activate --flake .#$HOST

all: update switch clean optimize
