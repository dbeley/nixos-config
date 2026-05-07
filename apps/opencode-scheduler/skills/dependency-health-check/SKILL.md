---
name: dependency-health-check
description: Checks for deprecated, unmaintained, or outdated dependencies and suggests replacements
---

## Purpose

Audit project dependencies for health: deprecation status, maintenance activity, known vulnerabilities.

## Instructions

1. Parse the project's dependency manifest (package.json, Cargo.toml, flake.nix, etc.)
2. For each direct dependency:
   - Check if the version is the latest stable release
   - Check if the package is deprecated or archived on its repository
   - Check the last commit date — flag if > 1 year without updates
3. Look for packages with known replacement recommendations
4. Check for packages that could be replaced by built-in language features
5. Flag dependencies that only provide trivial functionality (left-pad style)

## When to Skip

- Project uses a lockfile-based system where updates require careful review (flag but don't auto-update)
- No dependency manifest found

## Commit Convention

- Do NOT auto-commit dependency version bumps (these should be reviewed manually)
- Instead, open a PR with a report in the PR description summarizing findings
- Prefix PR title with `deps:`

## Output

Open a PR containing a markdown report at `DEPENDENCY_HEALTH_REPORT.md` with findings and recommendations. Do not modify lockfiles or version pins.
