# Repository Guidelines

## Project Structure and Modules
- `flake.nix` wires inputs, formatter/checks, and `nixosConfigurations`; `treefmt.nix` configures `nixfmt` + `statix`.
- `hosts/` holds per-machine configs; define hosts in `hosts/default.nix` via `mkHost`, with hardware files in `hosts/<host>/hardware-configuration.nix`.
- `modules/` contains shared NixOS modules (base system, overlays, disko/impermanence, hardware, sops); `apps/` bundles reusable DE/app modules (niri, hyprland, gnome, sway, browsers, editors, etc.).
- `pkgs/` carries custom packages/patches; `secrets/` is reserved for `sops-nix` data; `imgs/` stores assets/screenshots.
- `justfile` provides canned rebuild/cleanup tasks; keep environment variables (e.g., `HOST`) in `.env`.

## Build, Test, and Development Commands
- Rebuild current host: `HOST=<name> just switch` (wraps `sudo nixos-rebuild switch --flake .#$HOST --max-jobs auto`).
- Remote rebuild: `just switch-remote-host <host> <target>`; boot-only: `HOST=<name> just boot`.
- Update inputs: `just update`; cleanup: `just clean`; store optimize: `just optimize`.
- Lint/format: `nix fmt` (treefmt) and `nix flake check` (runs formatting check). Dry-run changes with `nixos-rebuild dry-activate --flake .#<name>` before switching.

## Coding Style and Naming
- Nix code uses 2-space indentation and `nixfmt` formatting; run `nix fmt` before committing. Address `statix` findings surfaced by `nix flake check`.
- Prefer hyphenated, lower-case module names (`modules/common`, `apps/hyprland`) and commit prefixes matching touched areas (`hyprland: ...`, `impermanence: ...`).
- Keep strings/files ASCII unless a module already uses Unicode (e.g., theme assets).

## Testing Guidelines
- Primary check is `nix flake check`; treat it as the pre-commit gate.
- For host changes, run `nixos-rebuild dry-activate --flake .#<host>` to catch evaluation errors; for remote targets, prefer dry-run before `switch-remote-host`.
- If altering packages under `pkgs/`, build them explicitly: `nix build .#<pkg>` to ensure derivations succeed.

## Commit and Pull Request Practices
- Use concise, imperative commits with scope prefixes: `area: action` (examples: `sudo: update settings`, `gnome: disable donation reminder`).
- In PRs/descriptions, include: affected hosts/profiles, key commands run (`nix flake check`, rebuild commands), and any visual changes (attach screenshots for DE/bar tweaks).
- Note any secrets handling (paths under `secrets/`) and call out required `.env` variables for `just` recipes.

## Security and Configuration Tips
- Do not commit unencrypted secrets; keep `secrets/` managed by `sops-nix` and ensure recipients/age keys are set before enabling.
- For impermanence/disko installs, ensure `hardware-configuration.nix` is present and persistent password files are created as described in `README.md`.
- For overlays/fixes, centralize changes in `modules/overlays.nix` to avoid per-host drift; prefer reusable profiles over host-specific patches.
