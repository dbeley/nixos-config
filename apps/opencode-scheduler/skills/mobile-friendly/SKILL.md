---
name: mobile-friendly
description: Checks if a web application or web-based UI is compatible with mobile devices — responsive design, touch targets, viewport configuration
---

## Purpose

Audit web frontends for mobile-friendliness without needing a physical device.

## Instructions

1. Check for viewport meta tag (`<meta name="viewport" content="width=device-width, initial-scale=1">`)
2. Audit CSS for:
   - Media queries for responsive breakpoints
   - Fixed-width elements that would overflow on small screens (< 375px)
   - Font sizes too small for mobile (< 14px base)
   - Touch targets smaller than 44x44px
3. Check for mobile-unfriendly patterns:
   - Hover-only interactions without touch equivalents
   - Horizontal scroll on narrow viewports
   - Fixed position elements blocking content
   - `user-scalable=no` preventing pinch-zoom
4. Verify images use responsive sizing (`max-width: 100%`, `srcset`)
5. Check JavaScript for touch event handling (`touchstart`, `touchend`)

## When to Skip

- Project has no web/frontend component
- Project is a CLI tool, system daemon, or backend service

## Commit Convention

- Prefix commit messages with `fix(a11y):` or `style(responsive):`
- Group changes by file/component

## Output

If issues found: open a PR with fixes. For changes that require UX decisions, describe the issue and suggest alternatives in the PR body rather than committing a solution.
