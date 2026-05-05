# opencode-scheduler Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build scheduled automated OpenCode jobs on nixos-era-01 that run headless via `opencode run --attach`, make code improvements, and open GitHub PRs — with sessions visible in the web UI.

**Architecture:** A new Nix module `apps/opencode-scheduler/` with system-level (linger) and home-manager parts (skills, config, runner script, 16 systemd timers + oneshot services). Each timer triggers a runner script that creates git worktrees, invokes `opencode run --attach` against the running opencode web server, then pushes branches and creates PRs via `gh`.

**Tech Stack:** Nix (module system), Bash (runner script), systemd (timers/services), OpenCode (headless `run` + web server API), GitHub CLI (`gh pr create`), sops-nix (secrets), jq (JSON parsing)

**Config format change from spec:** JSON instead of TOML (avoids extra dependency; jq is already installed)

---

### Task 1: Create module directory structure and system-level module

**Files:**
- Create: `apps/opencode-scheduler/default.nix`
- Create: `apps/opencode-scheduler/scripts/run-job.sh`

- [ ] **Step 1: Create directory structure**

```bash
mkdir -p apps/opencode-scheduler/scripts apps/opencode-scheduler/skills
```

- [ ] **Step 2: Write system-level module**

File: `apps/opencode-scheduler/default.nix`
```nix
{ ... }:
{
  # Linger is already enabled by opencode-server, but ensure it here for
  # standalone usage. The home-manager module declares the services/timers.
}
```

- [ ] **Step 3: Commit**

```bash
git add apps/opencode-scheduler/
git commit -m "feat(opencode-scheduler): add module skeleton"
```

---

### Task 2: Add GitHub fine-grained PAT to sops secrets

**Files:**
- Modify: `secrets/secrets.yaml` — add `github-fine-grained-pat`
- Modify: `modules/sops/sops.nix` — add decryption path

- [ ] **Step 1: Edit secrets.yaml**

Add to `secrets/secrets.yaml`:
```yaml
github-fine-grained-pat: "<placeholder>"
```

Run: `sops secrets/secrets.yaml` to edit and set the actual token.

- [ ] **Step 2: Wire sops decryption in home-manager module**

File: `modules/sops/sops.nix`

Add after the existing `opencode-server-password` block (around line 35):
```nix
"github-fine-grained-pat" = {
  path = "${config.home.homeDirectory}/.config/opencode-scheduler/github-token";
};
```

Ensure `~/.config/opencode-scheduler/` directory exists:
```nix
home.file.".config/opencode-scheduler/.keep".text = "";
```

- [ ] **Step 3: Commit**

```bash
git add secrets/secrets.yaml modules/sops/sops.nix
git commit -m "feat(sops): add github-fine-grained-pat secret"
```

---

### Task 3: Write the config template (JSON)

**Files:**
- Create: `apps/opencode-scheduler/config.json`

- [ ] **Step 1: Write config.json**

File: `apps/opencode-scheduler/config.json`
```json
{
  "repos_dir": "/home/david/projects",
  "repos": {
    "nixos-config": {
      "upstream": false,
      "skip": ["accessibility-checker"]
    },
    "nixpkgs": {
      "upstream": true,
      "skip": ["mobile-friendly"]
    }
  }
}
```

Description: `repos_dir` is the folder scanned for git repos. Any subfolder with `.git` is a target repo unless listed in `repos`. The `repos` map provides per-repo overrides: `skip` lists jobs to skip, `upstream: true` prevents automatic PR creation (changes are committed but not PR'd).

- [ ] **Step 2: Commit**

```bash
git add apps/opencode-scheduler/config.json
git commit -m "feat(opencode-scheduler): add config template"
```

---

### Task 4: Write the runner script

**Files:**
- Write: `apps/opencode-scheduler/scripts/run-job.sh`

- [ ] **Step 1: Write run-job.sh**

File: `apps/opencode-scheduler/scripts/run-job.sh`
```bash
#!/usr/bin/env bash
set -euo pipefail

SKILL="$1"
CONFIG="$HOME/.config/opencode-scheduler/config.json"
LOG_DIR="$HOME/.local/share/opencode-scheduler/logs/$SKILL"
TIMESTAMP=$(date +%Y-%m-%d-%H%M)
export OPENCODE_SERVER_PASSWORD="$(cat "$HOME/.config/opencode/opencode-server-password" 2>/dev/null || echo "")"

mkdir -p "$LOG_DIR"
LOG="$LOG_DIR/$TIMESTAMP.log"
exec > >(tee -a "$LOG") 2>&1

echo "=== opencode-scheduler: $SKILL ==="
echo "Started at $(date)"

if [ ! -f "$CONFIG" ]; then
    echo "ERROR: config not found at $CONFIG"
    exit 1
fi

REPOS_DIR=$(jq -r '.repos_dir // "/home/david/projects"' "$CONFIG")
export GITHUB_TOKEN="$(cat "$HOME/.config/opencode-scheduler/github-token" 2>/dev/null || echo "")"

for repo_path in "$REPOS_DIR"/*; do
    [ -d "$repo_path/.git" ] || continue
    REPO_NAME=$(basename "$repo_path")
    
    # Check skip list
    SKIP=$(jq -r ".repos[\"$REPO_NAME\"].skip // [] | index(\"$SKILL\")" "$CONFIG")
    if [ "$SKIP" != "null" ]; then
        echo "[$REPO_NAME] Skipping job '$SKILL' (in skip list)"
        continue
    fi
    
    # Determine upstream status
    IS_UPSTREAM=$(jq -r ".repos[\"$REPO_NAME\"].upstream // false" "$CONFIG")
    
    # Create worktree
    WORKTREE="/tmp/opencode-jobs/$REPO_NAME/$SKILL"
    mkdir -p "$(dirname "$WORKTREE")"
    git -C "$repo_path" worktree add --detach "$WORKTREE" HEAD 2>/dev/null || {
        echo "[$REPO_NAME] ERROR: Failed to create worktree"
        continue
    }
    trap "git -C '$repo_path' worktree remove --force '$WORKTREE' 2>/dev/null || true" EXIT
    
    # Record initial HEAD
    INITIAL_HEAD=$(git -C "$WORKTREE" rev-parse HEAD)
    echo "[$REPO_NAME] Initial HEAD: $INITIAL_HEAD"
    
    # Run opencode
    echo "[$REPO_NAME] Running opencode with skill '$SKILL'..."
    opencode run \
        --attach http://localhost:80 \
        --dir "$WORKTREE" \
        --agent scheduled-job \
        --dangerously-skip-permissions \
        "Load the skill '$SKILL' and execute it on the repository at $repo_path. Use the skill instructions to analyze and improve the codebase. Make changes as needed, commit them with descriptive messages, and push a new branch named 'auto/$SKILL/$TIMESTAMP'." || {
        echo "[$REPO_NAME] WARNING: opencode exited with non-zero status"
    }
    
    # Check for new commits
    NEW_HEAD=$(git -C "$WORKTREE" rev-parse HEAD)
    if [ "$INITIAL_HEAD" = "$NEW_HEAD" ]; then
        echo "[$REPO_NAME] No changes made"
    else
        echo "[$REPO_NAME] New commits detected"
        BRANCH="auto/$SKILL/$TIMESTAMP"
        git -C "$WORKTREE" checkout -b "$BRANCH" 2>/dev/null || true
        git -C "$WORKTREE" push origin "$BRANCH" 2>/dev/null || {
            echo "[$REPO_NAME] ERROR: Failed to push branch"
        }
        
        if [ "$IS_UPSTREAM" = "false" ]; then
            PR_URL=$(gh pr create \
                --repo "$REPO_NAME" \
                --head "$BRANCH" \
                --base main \
                --title "auto($SKILL): automated changes ($TIMESTAMP)" \
                --body "Automated changes from scheduled job: \`$SKILL\`\n\nRun at: $TIMESTAMP" \
                2>&1) || echo "[$REPO_NAME] PR creation failed: $PR_URL"
            echo "[$REPO_NAME] PR: $PR_URL"
        else
            echo "[$REPO_NAME] Skipping PR (upstream repo)"
        fi
    fi
    
    # Cleanup worktree for this repo
    git -C "$repo_path" worktree remove --force "$WORKTREE" 2>/dev/null || true
    trap - EXIT
done

echo "=== Finished at $(date) ==="
```

- [ ] **Step 2: Make script executable**

```bash
chmod +x apps/opencode-scheduler/scripts/run-job.sh
```

- [ ] **Step 3: Commit**

```bash
git add apps/opencode-scheduler/scripts/run-job.sh
git commit -m "feat(opencode-scheduler): add runner script"
```

---

### Task 5: Write daily skill files (7 skills)

**Files:**
- Create: `apps/opencode-scheduler/skills/security-auditor/SKILL.md`
- Create: `apps/opencode-scheduler/skills/dead-code-detector/SKILL.md`
- Create: `apps/opencode-scheduler/skills/test-gap-finder/SKILL.md`
- Create: `apps/opencode-scheduler/skills/dependency-health-check/SKILL.md`
- Create: `apps/opencode-scheduler/skills/doc-updater/SKILL.md`
- Create: `apps/opencode-scheduler/skills/readme-auditor/SKILL.md`
- Create: `apps/opencode-scheduler/skills/convention-enforcer/SKILL.md`

- [ ] **Step 1: Create skills directory**

```bash
mkdir -p apps/opencode-scheduler/skills/{security-auditor,dead-code-detector,test-gap-finder,dependency-health-check,doc-updater,readme-auditor,convention-enforcer}
```

- [ ] **Step 2: Write security-auditor skill**

File: `apps/opencode-scheduler/skills/security-auditor/SKILL.md`
```markdown
---
name: security-auditor
description: Scans codebase for security vulnerabilities — exposed secrets, unsafe eval patterns, missing input validation, outdated cryptographic practices
---

## Purpose

Audit the codebase for common security issues that static analysis tools may miss.

## Instructions

1. Search for hardcoded secrets: API keys, tokens, passwords, private keys in source files
2. Check for unsafe eval/exec patterns (`eval()`, `exec()`, `os.system()`, `subprocess` with `shell=True`)
3. Look for missing input validation on user-facing endpoints/function parameters
4. Identify use of outdated cryptographic algorithms (MD5, SHA1, DES, RC4)
5. Check for SQL injection vectors (string concatenation in queries)
6. Flag files with overly permissive permissions (chmod 777, mode 0777)
7. Look for debug endpoints or logging of sensitive data

## When to Skip

- No code changes in this iteration
- Project has no security-sensitive paths (pure documentation repos)

## Commit Convention

- Prefix commit messages with `security:` 
- Include file paths and issue type in the message

## Output

If issues found: open a PR with fixes. If none found: log "No security issues found" and exit.
```

- [ ] **Step 3: Write dead-code-detector skill**

File: `apps/opencode-scheduler/skills/dead-code-detector/SKILL.md`
```markdown
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
```

- [ ] **Step 4: Write test-gap-finder skill**

File: `apps/opencode-scheduler/skills/test-gap-finder/SKILL.md`
```markdown
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
```

- [ ] **Step 5: Write dependency-health-check skill**

File: `apps/opencode-scheduler/skills/dependency-health-check/SKILL.md`
```markdown
---
name: dependency-health-check
description: Checks for deprecated, unmaintained, or outdated dependencies and suggests replacements
---

## Purpose

Audit project dependencies for health: deprecation status, maintenance activity, known vulnerabilities.

## Instructions

1. Parse the project's dependency manifest (package.json, Cargo.toml, flake.nix, etc.)
2. For each direct dependency:
   - Check if the version is the latest stable release
   - Check if the package is deprecated or archived on its repository
   - Check the last commit date — flag if > 1 year without updates
3. Look for packages with known replacement recommendations
4. Check for packages that could be replaced by built-in language features
5. Flag dependencies that only provide trivial functionality (left-pad style)

## When to Skip

- Project uses a lockfile-based system where updates require careful review (flag but don't auto-update)
- No dependency manifest found

## Commit Convention

- Do NOT auto-commit dependency version bumps (these should be reviewed manually)
- Instead, open a PR with a report in the PR description summarizing findings
- Prefix PR title with `deps:`

## Output

Open a PR containing a markdown report at `DEPENDENCY_HEALTH_REPORT.md` with findings and recommendations. Do not modify lockfiles or version pins.
```

- [ ] **Step 6: Write doc-updater skill**

File: `apps/opencode-scheduler/skills/doc-updater/SKILL.md`
```markdown
---
name: doc-updater
description: Checks for outdated or missing docstrings, README sections, and inline documentation
---

## Purpose

Keep code documentation accurate and complete. Find stale docs, missing docstrings, and incomplete README sections.

## Instructions

1. Verify that all public functions/classes/methods have docstrings
2. Check that docstring parameter lists match actual function signatures
3. Look for TODO/FIXME/HACK comments that reference outdated information
4. Check README for:
   - Installation instructions match actual process
   - Usage examples still work with current API
   - Configuration options documented match actual config
   - Links are not broken (404)
5. Find documentation that references removed features or old APIs
6. Add missing docstrings following the project's existing docstring style

## When to Skip

- Project has no public API surface
- Documentation is intentionally minimal by design

## Commit Convention

- Prefix commit messages with `docs:` 
- Group changes by file/area

## Style

- Match the project's existing documentation style (JSDoc, Google-style Python, RDoc, etc.)
- Do not introduce new documentation frameworks
```

- [ ] **Step 7: Write readme-auditor skill**

File: `apps/opencode-scheduler/skills/readme-auditor/SKILL.md`
```markdown
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
```

- [ ] **Step 8: Write convention-enforcer skill**

File: `apps/opencode-scheduler/skills/convention-enforcer/SKILL.md`
```markdown
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
```

- [ ] **Step 9: Commit daily skills**

```bash
git add apps/opencode-scheduler/skills/{security-auditor,dead-code-detector,test-gap-finder,dependency-health-check,doc-updater,readme-auditor,convention-enforcer}/
git commit -m "feat(opencode-scheduler): add daily skill files (7 skills)"
```

---

### Task 6: Write weekly skill files (9 skills)

**Files:**
- Create: `apps/opencode-scheduler/skills/mobile-friendly/SKILL.md`
- Create: `apps/opencode-scheduler/skills/dependency-bump/SKILL.md`
- Create: `apps/opencode-scheduler/skills/feature-brainstormer/SKILL.md`
- Create: `apps/opencode-scheduler/skills/nix-package-updater/SKILL.md`
- Create: `apps/opencode-scheduler/skills/scaffolding-builder/SKILL.md`
- Create: `apps/opencode-scheduler/skills/ci-builder/SKILL.md`
- Create: `apps/opencode-scheduler/skills/pattern-enforcer/SKILL.md`
- Create: `apps/opencode-scheduler/skills/accessibility-checker/SKILL.md`
- Create: `apps/opencode-scheduler/skills/perf-profiler/SKILL.md`

- [ ] **Step 1: Create weekly skills directories**

```bash
mkdir -p apps/opencode-scheduler/skills/{mobile-friendly,dependency-bump,feature-brainstormer,nix-package-updater,scaffolding-builder,ci-builder,pattern-enforcer,accessibility-checker,perf-profiler}
```

- [ ] **Step 2: Write mobile-friendly skill**

File: `apps/opencode-scheduler/skills/mobile-friendly/SKILL.md`
```markdown
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
```

- [ ] **Step 3: Write dependency-bump skill**

File: `apps/opencode-scheduler/skills/dependency-bump/SKILL.md`
```markdown
---
name: dependency-bump
description: Attempts to update dependencies to their latest compatible versions and verifies them by running the project's build and test suite
---

## Purpose

Keep dependencies current by trying version bumps and verifying they work.

## Instructions

1. Parse the project's dependency manifest to find all direct dependencies
2. For each dependency with a newer version available:
   - Check the changelog for breaking changes
   - If non-breaking, bump the version
   - Run the project's build command
   - Run the project's test suite
   - If both pass, include the bump in the PR
   - If either fails, note it in the PR description and revert that specific bump
3. Focus on patch and minor version bumps (semver compatible)
4. Skip major version bumps unless the changelog shows trivial migration

## When to Skip

- Project has no automated build or test commands
- Project explicitly pins versions for stability reasons

## Commit Convention

- One commit per dependency bump (or group related bumps)
- Prefix commit messages with `deps:` 
- Include old version → new version in the commit message

## Safety

- Always revert individual bumps that break build/tests, do not skip the entire run
- Do not bump dependencies that are pinned for known reasons (documented in comments)
```

- [ ] **Step 4: Write feature-brainstormer skill**

File: `apps/opencode-scheduler/skills/feature-brainstormer/SKILL.md`
```markdown
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
```

- [ ] **Step 5: Write nix-package-updater skill**

File: `apps/opencode-scheduler/skills/nix-package-updater/SKILL.md`
```markdown
---
name: nix-package-updater
description: Checks Nix flake inputs for updates, tries to build after updating, creates update PRs
---

## Purpose

Keep Nix-based projects up to date by checking for flake input updates and verifying they build.

## Instructions

1. Check if the project uses Nix flakes (look for `flake.nix`, `flake.lock`)
2. For each flake input, check if a newer revision/version is available
3. For inputs that can be updated:
   - Run `nix flake lock --update-input <input>`
   - Try `nix build .#` or the project's build command
   - If the build succeeds, include the update
   - If it fails, revert and note the failure
4. Check `nixpkgs` input specifically — this is the most impactful update
5. Look for deprecated Nix APIs being used (check against nixpkgs release notes)

## When to Skip

- Project does not use Nix flakes
- Flake inputs reference specific commits that are intentionally pinned

## Commit Convention

- Commit message: `flake: update <input> (<old-version> → <new-version>)` 
- One commit per input update, or group non-breaking updates

## Safety

- Always build-test each update independently
- Do not update `nixpkgs` and other inputs simultaneously — separate PRs
- If `nixpkgs` update breaks the build, note the specific breakage in PR description
```

- [ ] **Step 6: Write scaffolding-builder skill**

File: `apps/opencode-scheduler/skills/scaffolding-builder/SKILL.md`
```markdown
---
name: scaffolding-builder
description: Reviews project structure and adds missing configuration files — editorconfig, formatters, linters, CI basics, dev tooling
---

## Purpose

Ensure projects have complete development scaffolding so new contributors can start quickly.

## Instructions

1. Check for presence of common config files:
   - `.editorconfig` — if missing and project is multi-language, create one
   - Formatter config (`.prettierrc`, `pyproject.toml` for black, `rustfmt.toml`, etc.)
   - Linter config (`.eslintrc`, `pylintrc`, `.clippy.toml`, etc.)
   - `.gitignore` — ensure common patterns for the project's languages are covered
   - `.gitattributes` — if missing, add with basic line-ending normalization
2. Check for development environment tooling:
   - `flake.nix` or `shell.nix` for Nix projects
   - `devcontainer.json` if applicable
   - `.env.example` if `.env` is used
3. Check contributing guide:
   - `CONTRIBUTING.md` or link in README
   - If missing, create a minimal one with setup steps
4. Check pre-commit hooks (`.pre-commit-config.yaml`, `lefthook.yml`, etc.)

## When to Skip

- Project already has comprehensive scaffolding
- Project is archived or explicitly marked as unmaintained

## Commit Convention

- One commit per config file added
- Prefix with `chore:` or `feat(dev):` 

## Safety

- Do not override existing config files — only add missing ones
- Follow the project's existing tool choices, don't introduce new tools
```

- [ ] **Step 7: Write ci-builder skill**

File: `apps/opencode-scheduler/skills/ci-builder/SKILL.md`
```markdown
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

- Do not change CI provider (e.g., GitHub Actions → GitLab CI) unless the project is already using the target provider
- Add new steps conservatively — prefer adding one step at a time
```

- [ ] **Step 8: Write pattern-enforcer skill**

File: `apps/opencode-scheduler/skills/pattern-enforcer/SKILL.md`
```markdown
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
```

- [ ] **Step 9: Write accessibility-checker skill**

File: `apps/opencode-scheduler/skills/accessibility-checker/SKILL.md`
```markdown
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
   - Heading hierarchy (h1 → h2 → h3, no skipped levels)
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
```

- [ ] **Step 10: Write perf-profiler skill**

File: `apps/opencode-scheduler/skills/perf-profiler/SKILL.md`
```markdown
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
   - `O(n^2)` or worse algorithms on potentially large inputs
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
```

- [ ] **Step 11: Commit weekly skills**

```bash
git add apps/opencode-scheduler/skills/{mobile-friendly,dependency-bump,feature-brainstormer,nix-package-updater,scaffolding-builder,ci-builder,pattern-enforcer,accessibility-checker,perf-profiler}/
git commit -m "feat(opencode-scheduler): add weekly skill files (9 skills)"
```

---

### Task 7: Create the scheduled-job agent definition

**Files:**
- Create: `apps/opencode-scheduler/agent/scheduled-job.md`

- [ ] **Step 1: Write agent file**

File: `apps/opencode-scheduler/agent/scheduled-job.md`
```markdown
---
name: scheduled-job
description: Autonomous agent for scheduled code improvement tasks. Runs headlessly without prompting for confirmation.
mode: primary
tools:
  bash: true
  read: true
  edit: true
  glob: true
  grep: true
  webfetch: true
  websearch: true
  skill: true
  task: true
  todowrite: true
  lsp: true
---

You are an autonomous code improvement agent running as a scheduled job. You operate without human supervision.

## Core Rules

1. **Autonomous**: Make decisions independently. Do not ask for confirmation unless a change could break the build or lose data.
2. **Conservative**: When unsure, prefer to document findings rather than make risky changes.
3. **Focused**: Only make changes related to the skill you were asked to execute. Do not go beyond the skill's scope.
4. **Compliant**: Use the `skill` tool to load the skill instructions, then follow them exactly.
5. **Proper commits**: Make clear, descriptive commit messages. Group related changes in one commit, unrelated changes in separate commits.
6. **Exit cleanly**: When done, state "Task complete" and stop. Do not start new unrelated work.

## Git Workflow

- Create a new branch as instructed by the runner script
- Commit changes with descriptive messages following the skill's commit convention
- Do NOT push or create PRs — the runner script handles that
- If you make no changes, state "No changes needed" and exit

## Environment

You are running on nixos-era-01, a NixOS server. You have access to:
- Git with GitHub authentication (GITHUB_TOKEN)
- Nix build tools (if applicable)
- Standard Unix utilities
```

- [ ] **Step 2: Commit**

```bash
git add apps/opencode-scheduler/agent/
git commit -m "feat(opencode-scheduler): add scheduled-job agent definition"
```

---

### Task 8: Write the home-manager module

**Files:**
- Create: `apps/opencode-scheduler/scheduler.nix`

- [ ] **Step 1: Write scheduler.nix**

File: `apps/opencode-scheduler/scheduler.nix`
```nix
{ config, pkgs, lib, ... }:

let
  cfg = config.opencode-scheduler;
  skillNames = [
    "security-auditor"
    "dead-code-detector"
    "test-gap-finder"
    "dependency-health-check"
    "doc-updater"
    "readme-auditor"
    "convention-enforcer"
    "mobile-friendly"
    "dependency-bump"
    "feature-brainstormer"
    "nix-package-updater"
    "scaffolding-builder"
    "ci-builder"
    "pattern-enforcer"
    "accessibility-checker"
    "perf-profiler"
  ];
  dailyJobs = [
    "security-auditor"
    "dead-code-detector"
    "test-gap-finder"
    "dependency-health-check"
    "doc-updater"
    "readme-auditor"
    "convention-enforcer"
  ];
  weeklyJobs = {
    "mobile-friendly" = "Sat *-*-* 05:00:00";
    "dependency-bump" = "Sat *-*-* 06:00:00";
    "feature-brainstormer" = "Sun *-*-* 05:00:00";
    "nix-package-updater" = "Sun *-*-* 06:00:00";
    "scaffolding-builder" = "Mon *-*-* 05:00:00";
    "ci-builder" = "Tue *-*-* 05:00:00";
    "pattern-enforcer" = "Wed *-*-* 05:00:00";
    "accessibility-checker" = "Thu *-*-* 05:00:00";
    "perf-profiler" = "Fri *-*-* 05:00:00";
  };
  dailyTimestamps = {
    "security-auditor" = "01:00";
    "dead-code-detector" = "01:30";
    "test-gap-finder" = "02:00";
    "dependency-health-check" = "02:30";
    "doc-updater" = "03:00";
    "readme-auditor" = "03:30";
    "convention-enforcer" = "04:00";
  };
  runScript = pkgs.writeShellApplication {
    name = "run-opencode-job";
    runtimeInputs = with pkgs; [ jq git gh ];
    text = builtins.readFile ./scripts/run-job.sh;
  };
in
{
  options.opencode-scheduler = {
    enable = lib.mkEnableOption "opencode-scheduler";
  };

  config = lib.mkIf cfg.enable {
    # Write skill files
    home.file = lib.mkMerge (
      map (name: {
        ".config/opencode/skills/${name}/SKILL.md" = {
          source = ./skills/${name}/SKILL.md;
        };
      }) skillNames
    );

    # Write agent definition
    home.file.".config/opencode/agent/scheduled-job.md" = {
      source = ./agent/scheduled-job.md;
    };

    # Write config template (user can override)
    home.file.".config/opencode-scheduler/config.json" = {
      source = ./config.json;
    };

    # Ensure directories exist
    home.file.".config/opencode-scheduler/.keep".text = "";
    home.file.".local/share/opencode-scheduler/logs/.keep".text = "";

    # Install runner script
    home.packages = [ runScript ];

    # Daily job services and timers (01:00 - 04:00 every day)
    systemd.user.services = lib.mkMerge (
      map (name: {
        "opencode-${name}" = {
          Unit = {
            Description = "OpenCode scheduled job: ${name}";
            After = [ "network.target" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${runScript}/bin/run-opencode-job ${name}";
            Environment = [
              "HOME=%h"
              "PATH=${pkgs.git}/bin:${pkgs.gh}/bin:${pkgs.jq}/bin:${pkgs.curl}/bin"
            ];
          };
        };
      }) skillNames
    );

    systemd.user.timers = lib.mkMerge (
      # Daily timers
      (map (name: {
        "opencode-${name}" = {
          Unit = {
            Description = "OpenCode scheduled job timer: ${name}";
          };
          Timer = {
            OnCalendar = "*-*-* ${dailyTimestamps.${name}}:00";
            Persistent = true;
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
        };
      }) dailyJobs) ++
      # Weekly timers
      (map (name: {
        "opencode-${name}" = {
          Unit = {
            Description = "OpenCode scheduled job timer: ${name}";
          };
          Timer = {
            OnCalendar = weeklyJobs.${name};
            Persistent = true;
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
        };
      }) (builtins.attrNames weeklyJobs))
    );
  };
}
```

- [ ] **Step 2: Commit**

```bash
git add apps/opencode-scheduler/scheduler.nix
git commit -m "feat(opencode-scheduler): add home-manager module with services and timers"
```

---

### Task 9: Add profile to hosts/default.nix and update nixos-era-01

**Files:**
- Modify: `hosts/default.nix`

- [ ] **Step 1: Add opencode-scheduler profile definition**

File: `hosts/default.nix`

Add to the `moduleProfiles` attrset (after the `opencode-server` profile around line 112):
```nix
"opencode-scheduler" = {
  systemModules = [ ../apps/opencode-scheduler/default.nix ];
  homeModules = [ ../apps/opencode-scheduler/scheduler.nix ];
};
```

- [ ] **Step 2: Add opencode-scheduler to nixos-era-01 profiles**

File: `hosts/default.nix`

Update the `nixos-era-01` host definition (around line 534):
```nix
nixos-era-01 = mkHost {
  hostName = "nixos-era-01";
  stateVersion = "26.05";
  profiles = [
    "bootloader-grub-bios"
    "openssh-server"
    "opencode-server"
    "opencode-scheduler"
    "sops"
    "productivity"
  ];
};
```

- [ ] **Step 3: Commit**

```bash
git add hosts/default.nix
git commit -m "feat(hosts): add opencode-scheduler profile to nixos-era-01"
```

---

### Task 10: Add skill permission to opencode server config

**Files:**
- Modify: `apps/opencode-server/opencode-server.nix`

- [ ] **Step 1: Update opencode-server config to allow skills**

File: `apps/opencode-server/opencode-server.nix`

Update the JSON config to add `skill` to permissions:
```json
"permission": { "edit": "allow", "bash": "allow", "skill": "allow" }
```

- [ ] **Step 2: Commit**

```bash
git add apps/opencode-server/opencode-server.nix
git commit -m "fix(opencode-server): allow skill tool in permissions"
```

---

### Task 11: Build and verify

- [ ] **Step 1: Build the nixos-era-01 configuration**

```bash
nix build .#nixosConfigurations.nixos-era-01.config.system.build.toplevel --max-jobs 2
```

- [ ] **Step 2: Run pre-commit check**

```bash
nix build .#checks.x86_64-linux.pre-commit-check --max-jobs 2
```

- [ ] **Step 3: Verify all expected files exist in the build output**

```bash
# Check that skill files are included
nix eval .#nixosConfigurations.nixos-era-01.config.home-manager.users.david.home.file --json | jq 'keys | map(select(startswith(".config/opencode/skills/")))'
```

- [ ] **Step 4: Commit any fixes**

```bash
git add -A && git commit -m "chore: build verification fixes"
```

---

### Task 12: Write post-deployment instructions

- [ ] **Step 1: Note what needs to be done on the server after deployment**

After deploying to nixos-era-01:

```bash
# 1. Edit secrets.yaml to set the actual GitHub fine-grained PAT
sops secrets/secrets.yaml

# 2. Deploy the configuration
just switch-proxmox-vm nixos-era-01 <ip>

# 3. On the server, enable and start all timers
systemctl --user enable opencode-{security-auditor,dead-code-detector,test-gap-finder,dependency-health-check,doc-updater,readme-auditor,convention-enforcer,mobile-friendly,dependency-bump,feature-brainstormer,nix-package-updater,scaffolding-builder,ci-builder,pattern-enforcer,accessibility-checker,perf-profiler}.timer

# 4. Start timers (they'll begin running at their scheduled times)
systemctl --user start opencode-{security-auditor,dead-code-detector,test-gap-finder,dependency-health-check,doc-updater,readme-auditor,convention-enforcer,mobile-friendly,dependency-bump,feature-brainstormer,nix-package-updater,scaffolding-builder,ci-builder,pattern-enforcer,accessibility-checker,perf-profiler}.timer

# 5. Verify timers are active
systemctl --user list-timers

# 6. Create the repos directory and clone repos
mkdir -p /home/david/projects
cd /home/david/projects
git clone git@github.com:dbeley/nixos-config.git
# ... clone other repos as needed

# 7. Test a single job manually
run-opencode-job security-auditor

# 8. Update config.json with your actual repos
vim ~/.config/opencode-scheduler/config.json
```

- [ ] **Step 2: Done**

No commit needed — these are runtime instructions.
