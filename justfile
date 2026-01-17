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

clean:
  @echo "Cleaning old generations and garbage collecting"
  nh clean all --keep-since 7d --keep 5

optimize:
  @echo "Cleaning and optimizing nix store"
  nh clean all --keep-since 7d --keep 5 --optimise

search query:
  @echo "Searching for packages: {{query}}"
  nh search {{query}}

info:
  @echo "Listing available generations"
  nh os info

first-install-disko host target:
  @echo "Installing host {{host}} on target disk {{target}}"
  sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake .#{{host}} --disk main {{target}} --show-trace

all: update switch clean optimize
