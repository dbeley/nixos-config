---
name: perf-profiler
description: Identifies performance hotspots — N+1 queries, expensive loops, large bundles, blocking operations
---

## Purpose

Find performance bottlenecks through static analysis (no runtime profiling).

## Instructions

1. Scan for common performance anti-patterns:
   - Database queries inside loops (N+1 problem)
   - Synchronous I/O in async contexts
   - Large object allocations in hot paths
   - Deep recursion without memoization
   - Unnecessary re-renders in UI code (derived state computed inline)
   - Large bundles from importing entire libraries instead of tree-shakeable imports
2. Check for missing optimizations:
   - Missing pagination on list endpoints
   - Missing debounce/throttle on expensive event handlers
   - Missing caching headers on static assets
   - Missing lazy loading for below-fold content
3. Identify expensive patterns:
   - O(n^2) or worse algorithms on potentially large inputs
   - Repeated JSON parsing/serialization
   - Excessive DOM manipulation in loops
4. Look for resource leaks:
   - Event listeners not cleaned up
   - Timers/intervals not cleared
   - Open file handles not closed

## When to Skip

- Project is under 500 lines
- Project is documentation-only or purely configuration

## Commit Convention

- Prefix with `perf:` for actual fixes
- Do NOT auto-fix without understanding — open a PR with findings at `PERFORMANCE_REVIEW.md`
- If fix is straightforward and safe, include it

## Output

Create or update `PERFORMANCE_REVIEW.md` with findings. For clear-cut fixes (N+1 queries, missing debounce), include the fix in the PR. For architectural changes, describe the issue and suggest solutions.
