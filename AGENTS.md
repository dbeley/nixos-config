# Repository Guidelines

## Project Structure and Modules

### Directory Layout
- **`flake.nix`** - Main flake configuration defining inputs, outputs (`nixosConfigurations`, `checks`, `devShells`), and system configurations
- **`hosts/`** - Per-machine configurations
  - Define hosts in `hosts/default.nix` via `mkHost` function
  - Each host has `hardware-configuration.nix` and `home.nix`
- **`modules/`** - Shared NixOS system modules organized by category:
  - `modules/common/` - Base system configurations (bootloaders, laptop settings, openssh, printing, virtualization, etc.)
  - `modules/disko/` - Declarative disk partitioning (LUKS + btrfs + impermanence)
  - `modules/impermanence/` - Ephemeral root filesystem configuration
  - `modules/hardware/` - Hardware-specific modules (hid-tmff2, throttled)
  - `modules/sops/` - Secrets management (system and home-manager)
  - `modules/cachix/` - Binary cache configurations (hyprland, niri, nix-community)
  - `configuration.nix` - Base system configuration (networking, locale, nix settings)
  - `overlays.nix` - System-wide package overlays
- **`apps/`** - Reusable application and desktop environment modules (81 total)
  - Desktop environments: `gnome/`, `hyprland/`, `niri/`, `sway/`
  - Terminals: `alacritty/`, `ghostty/`, `kitty/`
  - Editors: `emacs/`, `helix/`, `kakoune/`, `neovim-nixvim/`, `neovim-nvf/`, `vscode/`
  - Browsers: `firefox/`, `qutebrowser/`, `ungoogled-chromium/`, `zen-browser/`
  - Code agents: `copilot/`, `cursor/`, `opencode/`, `workmux/`
  - File managers: `lf/`, `nnn/`, `yazi/`
  - Media: `imv/`, `mpd/`, `mpv/`, `obs/`, `zathura/`
  - Wayland utilities: `gammastep/`, `hypridle/`, `hyprlock/`, `mako/`, `tofi/`, `waybar/`, etc.
  - See full list in exploration notes
- **`scripts/`** - Installation and utility scripts (e.g., `install-nixos.sh` for Proxmox VMs)
- **`secrets/`** - sops-nix encrypted secrets storage (`secrets.yaml`)
- **`imgs/`** - Assets, wallpapers, and screenshots
- **`justfile`** - Build and maintenance recipes
- **`.env`** - Environment variables for justfile (e.g., `HOST=x13`) - not committed to git

**Note:** There is NO `pkgs/` directory. Custom packages are defined inline within app modules (e.g., `apps/mpdscrobble/package.nix`, `apps/autoscreen/autoscreen.nix`).

### Host Definition with mkHost

Hosts are defined in `hosts/default.nix` using the `mkHost` function:

```nix
mkHost = {
  hostName,              # Required: hostname
  stateVersion,          # Required: NixOS state version (e.g., "24.05")
  system ? "x86_64-linux",  # Optional: system architecture
  profiles ? [],         # Optional: list of profile names to enable
  extraModules ? [],     # Optional: additional system modules
  extraHomeModules ? [], # Optional: additional home-manager modules
  homeConfig ? ../hosts/${hostName}/home.nix, # Optional: per-host home config
}
```

### Available Profiles (moduleProfiles)

**System profiles:**
- `laptop` - Power management, bluetooth, tuned
- `impermanence` - Disko + impermanence setup with automatic root cleanup
- `bootloader-systemd-boot` - Systemd-boot UEFI bootloader
- `bootloader-grub` - GRUB UEFI bootloader
- `sops` - Secrets management (system + home-manager)
- `openssh-server` - SSH server with GitHub key authentication
- `docker` - Docker virtualization
- `podman` - Podman virtualization
- `android-tools` - ADB and fastboot
- `steam` - Gaming with proton-ge
- `sunshine` - Game streaming server
- `qbittorrent` - Torrent client service

**Desktop environments:**
- `niri` - Niri wayland compositor + waybar + tofi + mako
- `hyprland` - Hyprland + waybar + tofi + mako + gaming autoscreen
- `gnome` - GNOME desktop with dconf settings
- `sway` - Sway + waybar + tofi + mako

**Applications:**
- `personal` - ledger, mpv, nextcloud-client, impulse
- `firefox` - Firefox browser with extensive policies and addons
- `chromium` - Ungoogled chromium
- `qutebrowser` - Qutebrowser with search engines
- `mpd` - MPD + mpdscrobble (Last.fm scrobbler)
- `python` - Python development with direnv
- `neovim-nvf` - Neovim with nvf configuration framework
- `vscode` - VS Code editor
- `emacs` - Emacs editor
- `kakoune` - Kakoune editor
- `obs` - OBS Studio
- `pycharm` - PyCharm IDE
- `moonlight` - Game streaming client
- `code-agents` - workmux, cursor, copilot, opencode

### Current Hosts

**Workstations:**
- `p14s` - Lenovo ThinkPad P14s Gen 4 (AMD Ryzen 7 7840U, niri, impermanence)
- `vaio` - Sony Vaio Pro PK13 (Intel Core i5-1035G1, niri, sops)
- `x13` - Lenovo ThinkPad X13 Gen 1 (AMD Ryzen 5 4650U, niri, impermanence)
- `x1yoga` - Lenovo ThinkPad X1 Yoga Gen 5 (Intel Core i5-10210U, gnome, impermanence)
- `latitude` - Dell Latitude 7420 (Intel Core i7-1165G7, niri)
- `cf-rz6` - Panasonic Let's Note CF-RZ6 (Intel Core i5-7Y57, niri, impermanence)
- `sg13` - Silverstone SG13 desktop (AMD Ryzen 9 5950X + RTX 3070, gnome)
- `x61s` - Lenovo Thinkpad X61s (Intel Core 2 Duo L7500, sway)

**Servers (Kimsufi Proxmox VMs):**
- `nixos-kimsufi-01` - qbittorrent server
- `nixos-kimsufi-02` - Basic server
- `nixos-kimsufi-03` - Docker server

**Servers (Era Local Proxmox VMs):**
- `nixos-era-01` - Basic server

## Testing Guidelines
- **For verification, run formatting checks only**: Use `nix build .#checks.x86_64-linux.pre-commit-check --max-jobs 2` to verify code formatting/linting without evaluating all NixOS configurations. This is the recommended approach for LLM agents to avoid memory exhaustion.
- **Why avoid full `nix flake check`**: Running `nix flake check` evaluates all 11+ host configurations simultaneously, which can consume 12GB+ of RAM and cause memory exhaustion on typical LLM agent environments. The pre-commit check covers formatting/linting requirements without this overhead.
- **For host-specific changes**: Run `nixos-rebuild dry-activate --flake .#<host>` to validate specific host configurations without evaluating all hosts.
- **For package changes**: Build packages explicitly with `nix build .#<pkg>` to ensure derivations succeed.
- **For systems with ample RAM** (>16GB): You can optionally run full `nix flake check` or `just check`, but this is not required for LLM agents.

### Host Configuration Testing
**Before deploying to a host:**
```bash
nixos-rebuild dry-activate --flake .#<host>  # Catch evaluation errors without applying
```

**For remote targets:**
- Test locally with `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` first
- Then use dry-run before `switch-proxmox-vm-local` or `switch-proxmox-vm-kimsufi`

### Package Testing
**When altering custom packages in `apps/`:**
```bash
nix build .#<pkg>  # Ensure derivation succeeds before committing
```

## Security and Configuration Tips

### Secrets Management
**DO NOT commit unencrypted secrets.** All secrets must be managed via `sops-nix`:

- **Configuration:** `.sops.yaml` defines age key and creation rules
- **Secrets file:** `secrets/secrets.yaml` (encrypted)
- **Age key location:** `~/.config/sops/age/keys.txt` (or `/home/${user}/.config/sops/age/keys.txt` for system)
- **Current status:** sops is configured but "unused for now" per README

**To enable sops on a host:**
1. Ensure age key exists at specified location
2. Add `sops` to host's `profiles` list in `hosts/default.nix`
3. Define secrets in `secrets/secrets.yaml` using `sops secrets/secrets.yaml`

### Impermanence/Disko Setup

**Critical requirements for impermanence hosts:**

1. **Hardware configuration:** `hosts/<host>/hardware-configuration.nix` must exist
   - Generate with: `nixos-generate-config --no-filesystems`

2. **Password file:** MANDATORY for immutable users
   ```bash
   mkpasswd > temp_passwd_file
   sudo mv temp_passwd_file /mnt/root/persistent/passwd_$USER
   sudo chown root:root /mnt/root/persistent/passwd_$USER
   ```

3. **Persistent directories:** See `modules/impermanence/default.nix` for 109+ persisted paths
   - System: `/etc/nixos`, `/var/log`, `/var/lib/nixos`, etc.
   - Home: `.config`, `.local`, `.ssh`, `.gnupg`, etc.

4. **Installation process:** See README.md for detailed disko installation steps

### Overlays and Package Fixes

**Centralize overlays in `modules/overlays.nix`** to avoid per-host drift.

**Current active overlays:**
- `niri` overlay (from niri input)

**Commented examples for fixing broken packages:**
- zoom, beets, audacity, jack1, claude-code, nvidia, xpadneo

**To add a new overlay:**
1. Edit `modules/overlays.nix`
2. Add overlay to `nixpkgs.overlays` list
3. Test with `nix build .#<pkg>` before committing

### Common Configuration Patterns

**System defaults (from `configuration.nix`):**
- Kernel: `linuxPackages_latest`
- Network: NetworkManager with iwd backend
- Audio: PipeWire with wireplumber (camera disabled)
- sudo: `sudo-rs` instead of traditional sudo
- Locale: French (`fr_FR.UTF-8`) with US international keyboard
- Garbage collection: Automatic weekly cleanup (>7 days old)
- Swap: Zram with zstd compression
