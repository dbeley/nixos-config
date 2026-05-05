---
name: test-gap-finder
description: Scans codebase for untested or under-tested code, writes missing tests
---

## Purpose

Find code paths that lack test coverage and write the missing tests.

## Instructions

1. Identify all test files in the project and map what they cover
2. Find source files with no corresponding test file
3. For files with tests, identify untested functions and edge cases
4. Write missing tests following the project's existing test patterns
5. Focus on: error handling paths, boundary conditions, common edge cases
6. Do not modify test framework configuration unless adding tests requires it

## When to Skip

- Project has no test infrastructure at all (no test runner, no test files)
- Project is a configuration/deployment repository with no runtime code

## Commit Convention

- Prefix commit messages with `test:`
- Group by module/area

## Testing Patterns

- Match the project's existing test framework and assertion style
- Use the same file naming convention (e.g., `test_*.py`, `*.test.js`, `*.spec.ts`)
