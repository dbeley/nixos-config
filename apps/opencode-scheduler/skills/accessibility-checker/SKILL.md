---
name: accessibility-checker
description: Checks web applications for accessibility issues — ARIA labels, color contrast, keyboard navigation, screen reader compatibility
---

## Purpose

Audit web frontends for accessibility compliance (WCAG 2.1 AA).

## Instructions

1. Audit HTML templates/components for:
   - Missing `alt` attributes on images
   - Missing `aria-label` or `aria-labelledby` on interactive elements
   - Form inputs missing associated `<label>` elements
   - Heading hierarchy (h1 to h2 to h3, no skipped levels)
   - `role` attributes on custom interactive elements
2. Check color contrast:
   - Text vs background contrast ratio >= 4.5:1 for normal text
   - Text vs background contrast ratio >= 3:1 for large text
3. Check keyboard navigation:
   - All interactive elements are focusable (`tabindex`)
   - Focus order is logical
   - `:focus-visible` styles are present
4. Verify semantic HTML:
   - `<nav>`, `<main>`, `<aside>`, `<header>`, `<footer>` used appropriately
   - Tables have `<th>` headers with `scope` attributes
5. Check for `prefers-reduced-motion` media query support
6. Verify skip-to-content links exist on content-heavy pages

## When to Skip

- Project has no web/frontend component
- Project is a CLI tool, API, or daemon

## Commit Convention

- Prefix commit messages with `fix(a11y):`
- Group changes by page/component

## Safety

- Color contrast changes should preserve the design's visual identity
- ARIA labels should be descriptive but concise
