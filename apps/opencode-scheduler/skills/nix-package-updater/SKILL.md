---
name: nix-package-updater
description: Checks Nix flake inputs for updates, tries to build after updating, creates update PRs
---

## Purpose

Keep Nix-based projects up to date by checking for flake input updates and verifying they build.

## Instructions

1. Check if the project uses Nix flakes (look for `flake.nix`, `flake.lock`)
2. For each flake input, check if a newer revision/version is available
3. For inputs that can be updated:
   - Run `nix flake lock --update-input <input>`
   - Try `nix build .#` or the project's build command
   - If the build succeeds, include the update
   - If it fails, revert and note the failure
4. Check `nixpkgs` input specifically — this is the most impactful update
5. Look for deprecated Nix APIs being used (check against nixpkgs release notes)

## When to Skip

- Project does not use Nix flakes
- Flake inputs reference specific commits that are intentionally pinned

## Commit Convention

- Commit message: `flake: update <input> (<old-version> to <new-version>)`
- One commit per input update, or group non-breaking updates

## Safety

- Always build-test each update independently
- Do not update `nixpkgs` and other inputs simultaneously — separate PRs
- If `nixpkgs` update breaks the build, note the specific breakage in PR description
