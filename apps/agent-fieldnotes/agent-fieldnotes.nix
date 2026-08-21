{ pkgs, ... }:
let
  repoUrl = "https://github.com/dbeley/agent-fieldnotes.git";
  # Cache location (reconstructible, not user data): respects XDG. The repo is
  # a throwaway working clone — its source of truth is GitHub — so it belongs in
  # the cache, not in ~/workspace (which is user data / backed up / indexed).
  repoName = "agent-fieldnotes";

  # `fieldnote` — self-bootstrapping wrapper. Clones the shared KB repo into the
  # cache on first use (impermanence-safe: auto-reclones if wiped), then
  # delegates to scripts/fieldnote-add.sh.
  fieldnote = pkgs.writeShellScriptBin "fieldnote" ''
    set -euo pipefail
    CACHE=''${XDG_CACHE_HOME:-$HOME/.cache}
    REPO="$CACHE/${repoName}"
    if [[ ! -d "$REPO/.git" ]]; then
      mkdir -p "$CACHE"
      echo "cloning agent-fieldnotes KB -> $REPO" >&2
      git clone --depth 1 "${repoUrl}" "$REPO"
    fi
    exec "$REPO/scripts/fieldnote-add.sh" "$@"
  '';
in
{
  home.packages = [ fieldnote ];

  # Global opencode instructions: read by every opencode agent on this host in
  # every project. Tells them to capture reusable, undocumented findings into
  # the shared field-notes KB via the `fieldnote` command and push via git.
  xdg.configFile."opencode/AGENTS.md".text = ''
    # Field notes (klog) — capture protocol

    While working, if you discover something yourself that is NOT already well
    documented on the internet (or is only scattered across many sources), and
    it is reusable and would help another agent or human, publish it to the
    shared field-notes knowledge base.

    ## When to publish
    - You figured out a workaround, API quirk, or environment gotcha that took
      real effort and is not documented in one obvious place.
    - You reassembled a working answer from pieces scattered across docs/forums.
    - A reader hitting the same wall in the future would thank you.

    ## When NOT to publish
    - Trivial / obvious things that one search finds.
    - One-off task output or progress.
    - Anything already documented in a canonical place.
    - Secrets, credentials, personal data.

    ## How to publish
      1. Run:  fieldnote "One line title of the finding"
         (clones the KB to ~/.cache/agent-fieldnotes if needed; creates
          entries/<id>.yaml as a draft and validates it locally).
      2. Fill in problem / solution / repro in that file.
      3. Commit + push (CI validates + publishes to GitHub Pages).
         The clone is at ~/.cache/agent-fieldnotes. Use a short alias:
           export KB=~/.cache/agent-fieldnotes
           git -C "$KB" add entries/<id>.yaml
           git -C "$KB" commit
           git -C "$KB" push

    ## Rules
    - Keep new entries `status: draft` unless you actually re-ran the repro and
      saw the expected output (CI enforces that verified needs proof).
    - Include `repro` (steps + expected_output) on every entry.
    - Prefer CC0 license so the knowledge is freely redistributable.

    Live site: https://dbeley.github.io/agent-fieldnotes/
    When about to solve a tricky problem, you may first query the KB:
      curl -s https://dbeley.github.io/agent-fieldnotes/search.json
  '';
}
