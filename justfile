set dotenv-load

default:
  just --list

update:
  nix flake update

switch:
  @echo "Rebuilding config for host $HOST with nh"
  nh os switch . -H $HOST

boot:
  @echo "Rebuilding config for host $HOST (available at next boot) with nh"
  nh os boot . -H $HOST

install-proxmox-vm-local hostname ip:
  @echo "Installing {{hostname}} on {{ip}} (local network)"
  scp scripts/install-nixos.sh nixos@{{ip}}:/tmp/
  @echo "Script uploaded. Now SSH to the VM and run:"
  @echo "  ssh nixos@{{ip}}"
  @echo "  bash /tmp/install-nixos.sh {{hostname}}"

switch-proxmox-vm-local hostname ip:
  @echo "Deploying config for {{hostname}} to {{ip}} (local network) with nh"
  nh os switch . -H {{hostname}} -- --target-host root@{{ip}}

install-proxmox-vm-kimsufi hostname ip:
  @echo "Installing {{hostname}} on {{ip}} via kimsufi jump host"
  scp -J kimsufi scripts/install-nixos.sh nixos@{{ip}}:/tmp/
  @echo "Script uploaded. Now SSH to the VM and run:"
  @echo "  ssh -J kimsufi nixos@{{ip}}"
  @echo "  bash /tmp/install-nixos.sh {{hostname}}"

switch-proxmox-vm-kimsufi hostname ip:
  @echo "Deploying config for {{hostname}} to {{ip}} via kimsufi jump host with nh"
  NIX_SSHOPTS="-J kimsufi" nh os switch . -H {{hostname}} -- --target-host {{ip}} --ask-sudo-password

clean:
  @echo "Cleaning up old generations and garbage with nh"
  nh clean all --keep 5 --keep-since 7d

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
