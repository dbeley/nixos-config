---
name: ci-builder
description: Reviews CI/CD pipeline for missing steps and improvements — testing, linting, building, caching
---

## Purpose

Improve CI/CD pipelines by adding missing checks, optimizing build times, and ensuring coverage.

## Instructions

1. Locate the CI configuration file (`.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, etc.)
2. Audit for common CI steps:
   - Linting step (code style, formatting)
   - Testing step with test suite execution
   - Build step (if applicable)
   - Dependency audit/security scan
3. Check for optimization opportunities:
   - Dependency caching (npm cache, pip cache, nix store cache)
   - Parallel job execution where possible
   - Matrix testing for multiple versions/OS if the project targets them
4. Verify CI triggers:
   - PRs trigger CI
   - Main branch pushes trigger CI
   - Scheduled runs for dependency checks (if applicable)
5. Add missing steps that match the project's language and toolchain

## When to Skip

- Project has no CI configuration at all and is a personal project (suggest adding one in PR description only)
- CI is managed externally (Jenkins, Buildkite, etc.) and config is not in the repo

## Commit Convention

- Prefix commit messages with `ci:`
- Group related CI changes

## Safety

- Do not change CI provider (e.g., GitHub Actions to GitLab CI) unless the project is already using the target provider
- Add new steps conservatively — prefer adding one step at a time
