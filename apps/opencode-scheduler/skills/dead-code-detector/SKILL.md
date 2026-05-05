---
name: dead-code-detector
description: Finds unused imports, dead functions, unreachable branches, and orphaned files
---

## Purpose

Identify and remove dead code to improve maintainability and reduce cognitive load.

## Instructions

1. Scan all source files for unused imports (imports not referenced in the file)
2. Find functions/classes that are defined but never called anywhere in the project
3. Identify unreachable code paths (code after `return`, `raise`, `throw`, or in impossible condition branches)
4. Locate files that are not imported or referenced by any other file
5. Find variables that are assigned but never read
6. Check for commented-out code blocks that should be removed

## When to Skip

- Project is a library where public API may be called externally
- Codebase is very small (< 5 files)

## Commit Convention

- Prefix commit messages with `chore:`
- One commit per category (unused imports, dead functions, unreachable code)

## Safety Rules

- Never delete public API exports without checking for external consumers
- Be conservative — if unsure whether something is used, flag it in a comment instead of deleting
