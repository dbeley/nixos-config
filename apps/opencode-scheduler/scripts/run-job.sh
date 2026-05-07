#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <skill>" >&2
    exit 1
fi

SKILL="$1"
CONFIG="$HOME/.config/opencode-scheduler/config.json"
LOG_DIR="$HOME/.local/share/opencode-scheduler/logs/$SKILL"
TIMESTAMP=$(date +%Y-%m-%d-%H%M)
OPENCODE_SERVER_PASSWORD="$(cat "$HOME/.config/opencode/opencode-server-password" 2>/dev/null || echo "")"
export OPENCODE_SERVER_PASSWORD

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
GITHUB_TOKEN="$(cat "$HOME/.config/opencode-scheduler/github-token" 2>/dev/null || echo "")"
export GITHUB_TOKEN

cleanup_worktree() {
    git -C "$1" worktree remove --force "$2" 2>/dev/null || true
}

shopt -s nullglob
for repo_path in "$REPOS_DIR"/*; do
    [ -d "$repo_path/.git" ] || continue
    REPO_NAME=$(basename "$repo_path")

    # Check skip list
    SKIP=$(jq -r --arg repo "$REPO_NAME" --arg skill "$SKILL" '.repos[$repo].skip // [] | index($skill)' "$CONFIG")
    if [ "$SKIP" != "null" ]; then
        echo "[$REPO_NAME] Skipping job '$SKILL' (in skip list)"
        continue
    fi

    # Determine upstream status
    IS_UPSTREAM=$(jq -r --arg repo "$REPO_NAME" '.repos[$repo].upstream // false' "$CONFIG")

    # Create worktree
    WORKTREE="/tmp/opencode-jobs/$REPO_NAME/$SKILL"
    mkdir -p "$(dirname "$WORKTREE")"
    git -C "$repo_path" worktree add --detach "$WORKTREE" HEAD 2>/dev/null || {
        echo "[$REPO_NAME] ERROR: Failed to create worktree"
        continue
    }
    trap 'cleanup_worktree "$repo_path" "$WORKTREE"' EXIT

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
shopt -u nullglob

echo "=== Finished at $(date) ==="
