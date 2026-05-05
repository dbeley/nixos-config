# opencode-scheduler — Design Spec

## Overview

Scheduled automated OpenCode jobs running on `nixos-era-01`, triggered via the OpenCode web API so sessions appear in the web UI for monitoring. Each job uses a custom skill that scans a configurable set of git repositories, makes improvements, and opens GitHub PRs with the changes.

## Architecture

```
~/.config/opencode/
├── skills/                          # Skill definition files (16 markdown files)
│   ├── test-gap-finder.md
│   ├── doc-updater.md
│   ├── convention-enforcer.md
│   ├── security-auditor.md
│   ├── dead-code-detector.md
│   ├── scaffolding-builder.md
│   ├── ci-builder.md
│   ├── pattern-enforcer.md
│   ├── accessibility-checker.md
│   ├── nix-package-updater.md
│   ├── dependency-health-check.md
│   ├── dependency-bump.md
│   ├── perf-profiler.md
│   ├── readme-auditor.md
│   ├── mobile-friendly.md
│   └── feature-brainstormer.md
├── scheduler/
│   ├── config.toml                  # Repo scanning config + per-repo overrides
│   └── run-job.sh                  # Generic runner (invoked by each timer)
└── opencode.json                    # (existing)

systemd user timers:
  opencode-security-auditor.timer        → OnCalendar daily 01:00
  opencode-dead-code-detector.timer      → OnCalendar daily 01:30
  opencode-test-gap-finder.timer         → OnCalendar daily 02:00
  opencode-dependency-health.timer       → OnCalendar daily 02:30
  opencode-doc-updater.timer             → OnCalendar daily 03:00
  opencode-readme-auditor.timer          → OnCalendar daily 03:30
  opencode-convention-enforcer.timer     → OnCalendar daily 04:00
  opencode-mobile-friendly.timer         → OnCalendar weekly Sat 05:00
  opencode-dependency-bump.timer         → OnCalendar weekly Sat 06:00
  opencode-feature-brainstormer.timer    → OnCalendar weekly Sun 05:00
  opencode-nix-package-updater.timer     → OnCalendar weekly Sun 06:00
  opencode-scaffolding-builder.timer     → OnCalendar weekly Mon 05:00
  opencode-ci-builder.timer              → OnCalendar weekly Tue 05:00
  opencode-pattern-enforcer.timer        → OnCalendar weekly Wed 05:00
  opencode-accessibility-checker.timer   → OnCalendar weekly Thu 05:00
  opencode-perf-profiler.timer           → OnCalendar weekly Fri 05:00
```

## Module Structure

```
apps/opencode-scheduler/
├── default.nix                  # System-level: linger, env vars
├── scheduler.nix                # Home-manager: packages, scripts, services, timers, skills
├── skills/                      # 16 skill markdown files
├── config.toml                  # Default repo scanning config
└── scripts/
    └── run-job.sh               # Generic runner script
```

### Profile Definition (in hosts/default.nix)

```nix
"opencode-scheduler" = {
  systemModules = [ ../apps/opencode-scheduler/default.nix ];
  homeModules = [ ../apps/opencode-scheduler/scheduler.nix ];
};
```

`nixos-era-01` adds `"opencode-scheduler"` to its profiles list.

## Job Flow (per repo, per job)

1. systemd timer fires, starts a oneshot service
2. `run-job.sh` reads `config.toml` for the repo folder path and per-repo rules
3. For each repo:
   a. Creates a git worktree from `main` into `/tmp/opencode-jobs/<repo>/<job>/`
   b. Injects `GITHUB_TOKEN` (from sops-decrypted file) as env var
   c. POSTs a session to the OpenCode web API (`localhost:80`) with the skill prompt + repo context
   d. Session runs autonomously, visible in the OpenCode web UI
   e. If changes were committed: pushes branch `auto/<job>/<date>`, opens PR via `gh pr create`
   f. If no changes: logs "no changes" and moves on
   g. Cleans up the worktree
4. Results logged to `~/.local/share/opencode-scheduler/logs/<job>/<date>.log`

## Scheduling Rationale

| Time | Freq | Job | Reason |
|------|------|-----|--------|
| 01:00 | Daily | security-auditor | Run first — catch secrets exposure ASAP |
| 01:30 | Daily | dead-code-detector | Fast static analysis |
| 02:00 | Daily | test-gap-finder | Original baseline pick |
| 02:30 | Daily | dependency-health-check | API calls for dep status |
| 03:00 | Daily | doc-updater | Original baseline pick |
| 03:30 | Daily | readme-auditor | Quick link/docs check |
| 04:00 | Daily | convention-enforcer | Original baseline pick |
| Sat 05:00 | Weekly | mobile-friendly | Speculative, once a week |
| Sat 06:00 | Weekly | dependency-bump | Heavy — tries builds |
| Sun 05:00 | Weekly | feature-brainstormer | Creative, once a week |
| Sun 06:00 | Weekly | nix-package-updater | Heavy — flake updates + builds |
| Mon 05:00 | Weekly | scaffolding-builder | Project structure review |
| Tue 05:00 | Weekly | ci-builder | CI pipeline review |
| Wed 05:00 | Weekly | pattern-enforcer | Architectural patterns |
| Thu 05:00 | Weekly | accessibility-checker | Web app a11y |
| Fri 05:00 | Weekly | perf-profiler | Heavy — may need to run the app |

Heavy jobs (builds, profiling) are scheduled with 1-hour gaps and on separate days from each other.

## config.toml

```toml
repos_dir = "/home/david/projects"

[repo."nixos-config"]
skip = ["accessibility-checker", "ci-builder"]
upstream = false

[repo."nixpkgs"]
skip = ["mobile-friendly"]
upstream = true  # no auto-PR on upstream repos
```

**Rules:**
- `repos_dir` — folder scanned for git repositories (any subfolder with a `.git` directory)
- Per-repo `skip` — list of job names to skip for that repo
- `upstream = true` — marks a repo as not belonging to the user; changes are committed locally and logged, but no PR is opened

## Secrets

- `github-fine-grained-pat` — new sops secret, decrypted to `~/.config/opencode-scheduler/github-token`
  - Scope: `contents:write`, `pull_requests:write` on selected repos
- `opencode-go-api-key` — existing, used by opencode for LLM calls
- `opencode-server-password` — existing, may be needed for API auth if the web API requires it

## Git Worktree Isolation

Each job creates an isolated git worktree to:
- Avoid conflicts with any running processes on the server
- Prevent partial/in-progress changes from leaking between jobs
- Allow concurrent jobs on different repos without collision

Worktrees are created in `/tmp/opencode-jobs/<repo>/<job>/` and cleaned up after the job completes.

## Skill File Format

Each skill is a markdown file that instructs OpenCode on:
- What to analyze (code patterns, file types, etc.)
- Project-specific conventions to follow
- How to make and commit changes (commit message format, branch naming)
- When to skip (conditions where no action is needed)

Skills are stored in `~/.config/opencode/skills/` and referenced by name when the job triggers.

## Logging

Output is logged to `~/.local/share/opencode-scheduler/logs/<job>/<date>.log` for post-hoc review. Each log entry includes:
- Repo name and path
- Timestamp
- OpenCode session ID (for cross-referencing in the web UI)
- Exit status
- PR URL (if created)
- Any errors

## Non-Goals (Out of Scope)

- Auto-PR on upstream/third-party repos (configurable via `upstream = true`)
- Email or webhook notifications for job results
- Job concurrency (currently sequential per job, could be added later)
- Retroactively running jobs on demand via CLI (could be added as a `just` command later)

## Host Configuration

`nixos-era-01` profile list after this change:
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
