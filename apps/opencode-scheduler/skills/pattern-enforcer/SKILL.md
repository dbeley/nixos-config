---
name: pattern-enforcer
description: Detects architectural pattern violations — modules importing internals, circular dependencies, wrong abstraction layers
---

## Purpose

Catch violations of the project's intended architecture — the kind of issues that linters can't find because they require understanding the project's design.

## Instructions

1. Infer the project's architectural patterns from existing code:
   - Module boundaries (what imports what)
   - Layering (presentation, business logic, data access)
   - Design patterns in use (MVC, hexagonal, onion, etc.)
2. Detect violations:
   - Inner layers importing from outer layers
   - Modules importing from each other bidirectionally (circular)
   - Business logic in presentation layer files
   - Data access code in business logic files
3. Check for consistency:
   - All modules of the same type follow the same structure
   - Error handling follows the same pattern everywhere
   - State management is consistent across the codebase
4. Flag concrete examples with file paths and line numbers

## When to Skip

- Project is too small to have meaningful architecture (< 1000 lines)
- Project is a monorepo with deliberately different patterns per package

## Commit Convention

- Do NOT auto-fix architectural issues — they require human judgment
- Prefix PR title with `refactor(arch):`
- Open a PR with a detailed report at `ARCHITECTURE_REVIEW.md` describing each violation and suggested fixes
- The PR description should explain why each violation matters

## Output

Create or update `ARCHITECTURE_REVIEW.md` with findings. Do not make code changes.
