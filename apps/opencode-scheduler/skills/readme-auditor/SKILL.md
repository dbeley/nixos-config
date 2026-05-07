---
name: readme-auditor
description: Checks README for completeness, broken links, and missing sections
---

## Purpose

Ensure README files are complete, accurate, and helpful for new contributors.

## Instructions

1. Check for standard README sections present and complete:
   - Project title and description
   - Installation/setup instructions
   - Usage examples (at least basic)
   - Configuration options
   - Contributing guide (or links to it)
   - License information
2. Verify all links in README are reachable (no 404s)
3. Check that badges (CI, coverage, version) are accurate
4. Ensure code examples in README are syntactically correct
5. Check that the README reflects the current project state (not outdated)
6. Add a "Quick Start" section if missing and the setup is non-trivial

## When to Skip

- No README file exists and the project is a library/utility that is not meant for external users
- README is intentionally minimal

## Commit Convention

- Prefix commit messages with `docs:`
- Reference the README file path

## Safety

- Do not rewrite large sections of prose — focus on factual accuracy
- Preserve the author's voice and existing structure
