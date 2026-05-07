---
name: scaffolding-builder
description: Reviews project structure and adds missing configuration files — editorconfig, formatters, linters, CI basics, dev tooling
---

## Purpose

Ensure projects have complete development scaffolding so new contributors can start quickly.

## Instructions

1. Check for presence of common config files:
   - `.editorconfig` — if missing and project is multi-language, create one
   - Formatter config (`.prettierrc`, `pyproject.toml` for black, `rustfmt.toml`, etc.)
   - Linter config (`.eslintrc`, `pylintrc`, `.clippy.toml`, etc.)
   - `.gitignore` — ensure common patterns for the project's languages are covered
   - `.gitattributes` — if missing, add with basic line-ending normalization
2. Check for development environment tooling:
   - `flake.nix` or `shell.nix` for Nix projects
   - `devcontainer.json` if applicable
   - `.env.example` if `.env` is used
3. Check contributing guide:
   - `CONTRIBUTING.md` or link in README
   - If missing, create a minimal one with setup steps
4. Check pre-commit hooks (`.pre-commit-config.yaml`, `lefthook.yml`, etc.)

## When to Skip

- Project already has comprehensive scaffolding
- Project is archived or explicitly marked as unmaintained

## Commit Convention

- One commit per config file added
- Prefix with `chore:` or `feat(dev):`

## Safety

- Do not override existing config files — only add missing ones
- Follow the project's existing tool choices, don't introduce new tools
