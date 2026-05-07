---
name: doc-updater
description: Checks for outdated or missing docstrings, README sections, and inline documentation
---

## Purpose

Keep code documentation accurate and complete. Find stale docs, missing docstrings, and incomplete README sections.

## Instructions

1. Verify that all public functions/classes/methods have docstrings
2. Check that docstring parameter lists match actual function signatures
3. Look for TODO/FIXME/HACK comments that reference outdated information
4. Check README for:
   - Installation instructions match actual process
   - Usage examples still work with current API
   - Configuration options documented match actual config
   - Links are not broken (404)
5. Find documentation that references removed features or old APIs
6. Add missing docstrings following the project's existing docstring style

## When to Skip

- Project has no public API surface
- Documentation is intentionally minimal by design

## Commit Convention

- Prefix commit messages with `docs:`
- Group changes by file/area

## Style

- Match the project's existing documentation style (JSDoc, Google-style Python, RDoc, etc.)
- Do not introduce new documentation frameworks
