---
name: feature-brainstormer
description: Analyzes project usage patterns, code structure, and user-facing features to generate creative feature ideas
---

## Purpose

Generate actionable feature ideas based on the project's actual code, patterns, and apparent use case.

## Instructions

1. Analyze the project to understand:
   - What problem does it solve?
   - Who is the target user?
   - What are the core features?
2. Look for natural extensions:
   - Features that similar projects offer but this one doesn't
   - Pain points visible in TODO comments, issue templates, or workarounds in code
   - Integration opportunities with popular tools in the project's ecosystem
3. Consider the codebase structure:
   - Are there stubs or placeholder functions suggesting planned features?
   - Are there configuration options that could be expanded?
4. Generate 3-5 specific, actionable feature proposals

## When to Skip

- Project is a fork that closely tracks upstream (brainstorming would be duplicated effort)

## Output

- Do NOT make code changes
- Open a PR that creates or updates `FEATURE_IDEAS.md` with:
  - One section per proposal
  - Description, rationale, implementation hints, and complexity estimate
- PR title: `docs: automated feature brainstorming`
