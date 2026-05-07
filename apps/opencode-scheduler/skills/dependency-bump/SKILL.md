---
name: dependency-bump
description: Attempts to update dependencies to their latest compatible versions and verifies them by running the project's build and test suite
---

## Purpose

Keep dependencies current by trying version bumps and verifying they work.

## Instructions

1. Parse the project's dependency manifest to find all direct dependencies
2. For each dependency with a newer version available:
   - Check the changelog for breaking changes
   - If non-breaking, bump the version
   - Run the project's build command
   - Run the project's test suite
   - If both pass, include the bump in the PR
   - If either fails, note it in the PR description and revert that specific bump
3. Focus on patch and minor version bumps (semver compatible)
4. Skip major version bumps unless the changelog shows trivial migration

## When to Skip

- Project has no automated build or test commands
- Project explicitly pins versions for stability reasons

## Commit Convention

- One commit per dependency bump (or group related bumps)
- Prefix commit messages with `deps:`
- Include old version to new version in the commit message

## Safety

- Always revert individual bumps that break build/tests, do not skip the entire run
- Do not bump dependencies that are pinned for known reasons (documented in comments)
