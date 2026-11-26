# nixos-config

NixOS flake for multiple machines. Base system config in `modules/configuration.nix`, package
overlays in `modules/overlays.nix`, per-machine configs in `hosts/`, reusable
app/desktop/server modules in `apps/` (one directory per app).

There is NO `pkgs/` directory — custom packages are defined inline in their app module
(e.g. `apps/mpdscrobble/package.nix`, `apps/autoscreen/autoscreen.nix`).

Hosts, profiles and apps change constantly, so no inventory is listed here. The
authoritative sources are `rg 'hostName =' hosts/default.nix`, the `moduleProfiles`
attrset in `hosts/default.nix`, `ls apps/` and `just --list`.

## Verify (do this, not `nix flake check`)

```bash
nix build .#checks.x86_64-linux.pre-commit-check --max-jobs 2
```

Runs nixfmt, statix, deadnix, shellcheck, ruff and end-of-file-fixer. `nix flake check`
evaluates every host at once (12 GB+ RAM) and is not expected to run on a dev machine.

- **Host change:** `nixos-rebuild dry-activate --flake .#<host>` or `just build`
- **Remote host:** `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
  first, then `just switch-proxmox-vm <host> <ip>` (or `boot-proxmox-vm`)
- **Package change:** `nix build .#<pkg>`

## Hosts

`hosts/default.nix` builds each host with:

```nix
mkHost = {
  hostName,                                   # required
  stateVersion,                               # required
  system ? "x86_64-linux",
  profiles ? [],                              # names from moduleProfiles
  extraModules ? [],
  extraHomeModules ? [],
  homeConfig ? ../hosts/${hostName}/home.nix,
}
```

The file also exports the `domain` specialArg used by every era VM service. Per-host
layout: `hosts/<host>/{hardware-configuration.nix,home.nix}`.

## Non-obvious details

- **Hyprland** (>= 0.53): hyprlang is gone. Config lives in
  `wayland.windowManager.hyprland.settings` with `configType = "lua"` (rendered as
  `~/.config/hypr/hyprland.lua`); dispatchers via `lib.generators.mkLuaInline`. Validate
  with `Hyprland --verify-config` after pointing `XDG_CONFIG_HOME` at a dir containing
  `hypr/hyprland.lua`. waybar 0.15 uses `hyprland/workspaces`, it has no `wlr/workspaces`.
- **Impermanence/disko:** `hosts/<host>/hardware-configuration.nix` must exist (generate
  with `nixos-generate-config --no-filesystems`); an immutable user needs a password file
  at `/mnt/root/persistent/passwd_$USER` before install; persisted paths live in
  `modules/impermanence/default.nix`; full install steps are in README.md.
- **ACME/HTTPS on era hosts:** `modules/acme/default.nix` does OVH DNS-01 and derives each
  host's cert SANs from its own nginx vhosts (per-host certs, avoiding LE's
  5-identical-certs/week duplicate limit). Enable by adding `acme` and `sops` to a host's
  profiles. `forceSSL = true` requires port 80 open (redirect only; issuance is DNS-01).
- **Overlays:** edit `modules/overlays.nix` and test with `nix build .#<pkg>`; do not patch
  packages per host.
- **`apps/scripts/`** holds the shell helpers: the yt pickers (`ytq`, `ytf`, `ytc`) pipe
  through `yt-rows.nix` for identical fzf formatting, use `api.nix` for youtubei calls and
  `ytdlp.nix` (browser cookies) for downloads; `yt-preview.nix` is the shared fzf preview.

## Secrets (sops-nix)

Never commit plaintext secrets. `.sops.yaml` holds the age key and creation rules,
ciphertext lives in `secrets/*.yaml`, the age key at `~/.config/sops/age/keys.txt`.
Edit with `just secrets-edit`, inspect with `just secrets-view`. Enabling sops on a host
means the age key exists and `sops` is in its `profiles`.

Secrets consumed by `environmentFile` / OCI `--env-file` **must** be stored as `KEY=VALUE`
lines, not raw values — systemd and podman's `--env-file` both expect that format:

| Secret | File | Format |
|--------|------|--------|
| `bookorbit_env`, `youtarr_env`, `yamtrack_env`, `navidrome_env` | `secrets/nixflix.yaml` | multi-line `KEY=VALUE` |
| `trek_env`, `slskd_env`, `maloja_env` | `secrets/homelab.yaml` | multi-line `KEY=VALUE` |
| `audiomuse_pg_password` | `secrets/homelab.yaml` | `POSTGRES_PASSWORD=<value>` |
| `opencode_env`, `zeroclaw_env`, `hermes_webui_env` | `secrets/agents.yaml` | multi-line `KEY=VALUE` |
| `acme_ovh` | `secrets/acme.yaml` | multi-line `KEY=VALUE` |
| `urbanterror_env` | `secrets/urbanterror.yaml` | multi-line `KEY=VALUE`; keys are Quake cvars (`rconpassword`, `sv_hostname`, …), `SETS_Admin`/`SETS_Location` set browser tags |

Update with: `sops set <file> '["<key>"]' '"KEY=VALUE"'`

## Build

Builds go through `nh` (`programs.nh.enable`); `just --list` is the authoritative list of
recipes (switch, boot, test, build, update, rollback, proxmox deploy, secrets, …).
`HOST=<host>` in the environment or in `.env` selects the target host. GC is handled by
`nh clean` (keeps 7 days + 5 generations); `nix.gc.automatic` is intentionally disabled.

System defaults (kernel, locale, NetworkManager/iwd, PipeWire, sudo-rs, zram, nh) live in
`modules/configuration.nix` — read it instead of assuming.
