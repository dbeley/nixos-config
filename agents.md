# Agents Guide for `nixos-config`

## Project Snapshot
- Flake-based NixOS configuration reused across multiple machines (laptops, desktops, servers).
- Main user is `david`; Home Manager is enabled for this user on each host.
- Key inputs: nixpkgs `nixos-unstable`, home-manager, stylix, disko, impermanence, niri/hyprland stacks, sops-nix, treefmt-nix.
- Hosts are declared via `mkHost` in `hosts/default.nix`; reusable profiles bundle system/home modules.

## Layout
- `flake.nix`: inputs, supported systems, formatter/checks, `nixosConfigurations`.
- `hosts/`: per-host configs. `hosts/default.nix` wires profiles; `hosts/<host>/` holds `hardware-configuration.nix` (+ optional `home.nix`).
- `modules/`: shared NixOS modules (base config, overlays, cachix, disko, impermanence, hardware/common, sops).
- `apps/`: reusable app/DE modules for NixOS and Home Manager (niri, hyprland, gnome, sway, stylix, browsers, editors, etc.).
- `pkgs/`: custom packages/patches (e.g., `hid-tmff2`).
- `justfile`: canned rebuild/cleanup commands.
- `secrets/`: for sops-nix (unused in some hosts; check before editing).

## Working With Hosts
1) Generate/copy `hardware-configuration.nix` into `hosts/<host>/`.  
2) Add a `mkHost` entry in `hosts/default.nix` with `hostName`, `stateVersion`, optional `system` (defaults to `x86_64-linux`), and `profiles`.  
3) Optional: set `extraModules`/`extraHomeModules`/`homeConfig` for host-specific tweaks.  
4) Rebuild with the new target (see commands below).

### Profiles (selected)
- `laptop` (common laptop tweaks + fingerprint), `impermanence` (disko + impermanence on btrfs), `bootloader-*` (systemd-boot or grub variants).
- DE/WM: `niri`, `hyprland`, `gnome`, `sway` (each pulls relevant apps/home modules).
- Extras: `steam`, `android-tools`, `docker`, `podman`, `mpd`, `python`, `firefox`, `chromium`, `personal`, `code-agents` (codex/cursor), etc.
- Server-ish: `openssh-server`.

## Home Manager
- Enabled in `hosts/default.nix` for `${user}` with common imports from `hosts/home-manager-common-config.nix` and base apps (`fish`, `tmux`, `helix`, `nnn`, `yazi`, `stylix`, etc.).
- Add per-host overrides via `homeConfig` in `mkHost` or by extending `extraHomeModules`.

## Commands and Tooling
- Rebuild current host: `HOST=<name> just switch` or `sudo nixos-rebuild switch --flake .#<name>`.
- Remote rebuild: `just switch-remote-host <name> <target>` (uses ssh with sudo).
- Boot-only generation: `HOST=<name> just boot`.
- Update inputs: `just update`.
- Cleanup: `just clean`; store optimize: `just optimize`.
- Format: `nix fmt` (treefmt with nixfmt/statix); lint/check: `nix flake check`.
- Typical inspect: `nixos-rebuild dry-activate --flake .#<name>` before switching.

## Temporary Packages / Testing
- Ad-hoc shell: `nix shell nixpkgs#<pkg>` (or multiple packages).  
- Run a flake app/package: `nix run .#<pkg>` or `nix run nixpkgs#<pkg>`.  
- Interactive dev shell (no devShell defined): `nix develop` falls back to default; prefer `nix shell` for now.  
- Use `nix repl` with `flakes` feature for quick evaluations; `nix why-depends` for dependency tracing.

## Conventions and Tips
- Keep edits in ASCII; run `nix fmt` before commits.  
- Overlay fixes live in `modules/overlays.nix`; add cross-host package overrides there.  
- Stylix themes are applied globally; per-host wallpaper can be set in `extraModules` via `my.stylix.wallpaper`.  
- Impermanence/disko installs need persistent password file (see README install section).  
- sops-nix plumbing exists; ensure secrets are encrypted and paths match before enabling on new hosts.  
- When adding new profiles/apps, prefer small modules under `modules/` or `apps/` and compose them via `moduleProfiles` in `hosts/default.nix`.  
- For troubleshooting services: `sudo journalctl -u <unit>`, `nixos-option <opt>` to inspect evaluated options, `home-manager generations` for HM rollbacks.
