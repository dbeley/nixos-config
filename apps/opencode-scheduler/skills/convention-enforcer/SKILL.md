---
name: convention-enforcer
description: Reviews code for style and convention violations that linters don't catch — naming patterns, architectural decisions, code organization
---

## Purpose

Enforce project-specific conventions that go beyond what automated formatters and linters check.

## Instructions

1. Check naming conventions:
   - Files and directories follow the project's naming pattern
   - Function/variable names are consistent (camelCase vs snake_case)
   - Constants are properly named (UPPER_CASE or other convention)
2. Code organization:
   - Imports follow the project's ordering convention
   - Files are not excessively large (>500 lines suggests splitting)
   - Related functionality is grouped together
3. Architectural patterns:
   - Modules interact through defined interfaces, not internal imports
   - Dependency direction follows the project's layering rules
   - No circular dependencies between modules
4. Error handling consistency:
   - Error types/patterns are used consistently
   - Error messages follow the project's style
5. Comment quality:
   - Comments explain "why", not "what"
   - No commented-out code blocks

## When to Skip

- Project has fewer than 10 source files
- Project explicitly documents that conventions are not enforced

## Commit Convention

- Prefix commit messages with `style:` for naming/formatting
- Prefix with `refactor:` for organizational changes
- Group by type of violation

## Safety

- Do not change public API signatures without strong justification
- If a convention is ambiguous, follow existing patterns in the codebase rather than imposing new ones
