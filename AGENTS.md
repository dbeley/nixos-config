# Repository Guidelines

## Project Structure and Modules

### Directory Layout
- **`flake.nix`** - Main flake configuration defining inputs, outputs (`nixosConfigurations`, `checks`, `devShells`), and system configurations
- **`hosts/`** - Per-machine configurations
  - Define hosts in `hosts/default.nix` via `mkHost` function
  - Each host has `hardware-configuration.nix` and `home.nix`
- **`modules/`** - Shared NixOS system modules organized by category:
  - `modules/common/` - Base system configurations (bootloaders, laptop settings, laptop-thermald, openssh, printing, screen-rotation, virtualization, xbox, etc.)
  - `modules/disko/` - Declarative disk partitioning (LUKS + btrfs + impermanence)
  - `modules/impermanence/` - Ephemeral root filesystem configuration
  - `modules/hardware/` - Hardware-specific modules (hid-tmff2, throttled)
  - `modules/sops/` - Secrets management (system and home-manager)
  - `modules/cachix/` - Binary cache configurations (niri, nix-community)
  - `configuration.nix` - Base system configuration (networking, locale, nix settings)
  - `overlays.nix` - System-wide package overlays
- **`apps/`** - Reusable application and desktop environment modules (91 directories, 106 .nix files total)
  - Desktop environments: `gnome/`, `niri/`, `sway/`
  - Terminals: `alacritty/`, `ghostty/`, `kitty/`
  - Editors: `editorconfig/`, `emacs/`, `helix/`, `kakoune/`, `neovim-nixvim/`, `neovim-nvf/`, `nvim/`, `vscode/`
  - Browsers: `firefox/`, `qutebrowser/`, `ungoogled-chromium/`, `zen-browser/`
  - Code agents: `beads/`, `claude/`, `codex/`, `copilot/`, `cursor/`, `gemini/`, `goose/`, `hermes/`, `oh-my-opencode/`, `oh-my-pi/`, `opencode/`, `openskills/`, `pi/`, `rtk/`, `workmux/`
  - File managers: `lf/`, `nnn/`, `yazi/`
  - Media: `feishin/`, `imv/`, `mpd/`, `mpv/`, `obs/`, `swayimg/`, `zathura/`
  - Wayland utilities: `gammastep/`, `hyprlock/`, `mako/`, `noctalia/`, `swayidle/`, `swaylock/`, `tofi/`, `waybar/`, `wofi/`
  - Shell/CLI tools: `bat/`, `btop/`, `direnv/`, `fish/`, `git/`, `jj/`, `lazygit/`, `mime/`, `tealdeer/`, `tmux/`, `workstation/`, `zoxide/`
  - Networking: `mullvad/`
  - AI/ML: `ollama/`
  - Servers: `adguard-home/`, `hermes-server/`, `nextcloud-server/`, `nixflix/`, `opencode-server/`
  - Other apps: `android/`, `autoscreen/`, `boinc/`, `docker/`, `flatpak/`, `impulse/`, `ledger/`, `moonlight/`, `mpdscrobble/`, `nextcloud-client/`, `podman/`, `pycharm/`, `python/`, `qbittorrent/`, `restic/`, `steam/`, `stylix/`, `sunshine/`, `symmetri/`, `udiskie/`
- **`scripts/`** - Installation and utility scripts (e.g., `install-nixos.sh` for Proxmox VMs)
- **`secrets/`** - sops-nix encrypted secrets storage (`secrets.yaml`)
- **`imgs/`** - Assets, wallpapers, and screenshots
- **`justfile`** - Build and maintenance recipes
- **`iso-configs/`** - Custom ISO installer configuration for NixOS installations
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
- `laptop` - Power management, bluetooth, tuned, fingerprint scanner
- `impermanence` - Disko + impermanence setup with automatic root cleanup
- `bootloader-systemd-boot` - Systemd-boot UEFI bootloader
- `bootloader-grub-uefi` - GRUB UEFI bootloader
- `bootloader-grub-bios` - GRUB BIOS bootloader
- `sops` - Secrets management (system + home-manager)
- `openssh-server` - SSH server with GitHub key authentication
- `docker` - Docker virtualization
- `podman` - Podman virtualization
- `android-tools` - ADB and fastboot
- `steam` - Gaming with proton-ge
- `sunshine` - Game streaming server
- `qbittorrent` - Torrent client service

**Desktop environments:**
- `niri` - Niri wayland compositor + noctalia + autoscreen + ghostty
- `niri-waybar` - Niri wayland compositor + waybar + tofi + mako + hyprlock + swayidle + autoscreen + ghostty
- `gnome` - GNOME desktop with dconf settings
- `sway` - Sway + waybar + tofi + mako + swaylock + autoscreen + kitty

**Applications:**
- `workstation` - bat, btop, editorconfig, fish, git, helix, lazygit, ledger, mime, mpv, nextcloud-client, stylix, swayimg, tealdeer, tmux, udiskie, workstation, yazi, zathura, zoxide (system modules: stylix, udiskie, symmetri, workstation)
- `firefox` - Firefox browser with extensive policies and addons
- `chromium` - Ungoogled chromium
- `zen-browser` - Zen browser
- `qutebrowser` - Qutebrowser with search engines
- `mpd` - MPD + mpdscrobble (Last.fm scrobbler)
- `python` - Python development with direnv
- `neovim-nvf` - Neovim with nvf configuration framework
- `vscode` - VS Code: editor
- `emacs` - Emacs editor
- `kakoune` - Kakoune editor
- `obs` - OBS Studio
- `pycharm` - PyCharm IDE
- `moonlight` - Game streaming client
- `code-agents` - workmux, opencode, openskills, rtk, hermes, goose
- `jj` - Jujutsu version control system
- `mullvad` - Mullvad VPN (system + home-manager)
- `ollama` - Ollama local LLM server
- `hermes-server` - Hermes Web UI (port 80), NixOS system service with sops auth
- `nextcloud-server` - Nextcloud server
- `restic` - Restic backup tool

**Servers:**
- `nixflix` - Nixflix media server
- `opencode-server` - OpenCode server
- `hermes-server` - Hermes Web UI
- `adguard-home` - AdGuard Home DNS ad-blocker
- `nextcloud-server` - Nextcloud server

### Current Hosts

**Workstations:**
- `p14sg6` - Lenovo ThinkPad P14s Gen 6 (AMD Ryzen AI 7 350, niri, impermanence)
- `cf-qv1` - Panasonic Let's Note CF-QV1 (Intel Core i5-1145G7, niri, impermanence)
- `x1yoga` - Lenovo ThinkPad X1 Yoga Gen 5 (Intel Core i5-10210U, gnome, impermanence)
- `latitude` - Dell Latitude 7420 (Intel Core i7-1165G7, niri)
- `sg13` - Silverstone SG13 desktop (AMD Ryzen 9 5950X + RTX 3070, gnome)

**Deprecated workstations (no longer in `hosts/default.nix`):**
- `vaio` - Sony Vaio Pro PK13 (Intel Core i5-1035G1, niri, sops)
- `x13` - Lenovo ThinkPad X13 Gen 1 (AMD Ryzen 5 4650U, niri, impermanence)
- `cf-rz6` - Panasonic Let's Note CF-RZ6 (Intel Core i5-7Y57, niri, impermanence)
- `p14s` - Lenovo ThinkPad P14s Gen 4 (AMD Ryzen 7 7840U, niri, impermanence)
- `x61s` - Lenovo Thinkpad X61s (Intel Core 2 Duo L7500, sway)

**Servers (Kimsufi Proxmox VMs):**
- `nixos-kimsufi-01` - qbittorrent server
- `nixos-kimsufi-02` - unused
- `nixos-kimsufi-03` - unused

**Servers (ERA VPS):**
- `nixos-era-01` - Hermes Web UI
- `nixos-era-02` - Nixflix media server
- `nixos-era-03` - AdGuard Home DNS server
- `nixos-era-04` - Nextcloud server

## Testing Guidelines
- **For verification, run formatting checks only**: Use `nix build .#checks.x86_64-linux.pre-commit-check --max-jobs 2` to verify code formatting/linting without evaluating all NixOS configurations. This is the recommended approach for LLM agents to avoid memory exhaustion.
- **Why avoid full `nix flake check`**: Running `nix flake check` evaluates all 12 active host configurations simultaneously, which can consume 12GB+ of RAM and cause memory exhaustion on typical LLM agent environments. The pre-commit check covers formatting/linting requirements without this overhead.
- **For host-specific changes**: Run `nixos-rebuild dry-activate --flake .#<host>` or `just build` to validate specific host configurations without evaluating all hosts.
- **For package changes**: Build packages explicitly with `nix build .#<pkg>` to ensure derivations succeed.
- **For systems with ample RAM** (>16GB): You can optionally run full `nix flake check`, but this is not required for LLM agents.

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

### Build System and Deployment

**Build tool:** This repository uses `nh` (Yet Another Nix Helper) as the primary build tool, configured via `programs.nh.enable` in `modules/configuration.nix`.

**Justfile commands:**
- `just switch` - Build and activate configuration (uses `nh os switch`)
- `just boot` - Build and set as boot default (uses `nh os boot`)
- `just test` - Build and activate without bootloader update (uses `nh os test`)
- `just build` - Just build the configuration (uses `nh os build`)
- `just clean` - Manual garbage collection (uses `nh clean all --keep-since 7d --keep 5`)
- `just update` - Update flake inputs
- `just optimize` - Optimize nix store
- `just rollback` - Roll back to previous generation (uses `nh os rollback`)
- `just build-iso-image` - Build generic installer ISO
- `just install-proxmox-vm <hostname> <ip>` - Upload install script to Proxmox VM
- `just switch-proxmox-vm <hostname> <ip>` - Deploy config to remote Proxmox VM
- `just boot-proxmox-vm <hostname> <ip>` - Deploy config to remote Proxmox VM (boot only)
- `just search <query>` - Search for packages (uses `nh search`)
- `just info` - List available generations (uses `nh os info`)
- `just first-install-disko <host> <target>` - Run disko-install for a host on target disk
- `just flake-linter` - Run flake linter (uses `flake-linter`)
- `just nix-olde` - Check for outdated packages (uses `nix-olde`)
- `just secrets-edit` - Edit encrypted secrets with sops
- `just secrets-view` - View decrypted secrets
- `just secrets-gen-key` - Generate new age key for sops
- `just secrets-test` - Test sops configuration for current host
- `just all` - Update, switch, clean, and optimize in sequence

**Environment variables:**
- Set `HOST` environment variable (e.g., `export HOST=x13`) or create a `.env` file with `HOST=<hostname>`
- The `nh` module can optionally use `programs.nh.flake` to set the default flake path

**Garbage collection:**
- Automatic GC is handled by `programs.nh.clean.enable = true`
- Systemd service runs periodically with `--keep-since 7d --keep 5` (keeping generations from last 7 days AND 5 most recent)
- Manual cleanup available via `just clean` (keeps 7 days + 5 generations) or `just optimize` (also optimizes store)
- Traditional `nix.gc.automatic` is disabled to avoid conflicts

### Common Configuration Patterns

**System defaults (from `configuration.nix`):**
- Kernel: `linuxPackages_latest`
- Network: NetworkManager with iwd backend, BBR congestion control
- Audio: PipeWire with wireplumber (camera disabled)
- sudo: `sudo-rs` instead of traditional sudo
- Locale: French (`fr_FR.UTF-8`) with US international keyboard
- Build tool: `nh` (Yet Another Nix Helper) configured via `programs.nh.enable`
- Garbage collection: Managed by `nh clean` service (keeps last 7 days + 5 generations)
- Swap: Zram with zstd compression
- Services: systemd-resolved, gvfs, fstrim, gnome-keyring with gcr-ssh-agent, earlyoom
- Nix settings: `auto-optimise-store`, `keep-outputs`, `keep-derivations`, `nixVersions.latest`, `trusted-users` includes user

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->
