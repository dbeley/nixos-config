{ inputs, pkgs, ... }:
let
  # The `fieldnote` command logic lives ONCE, in the agent-fieldnotes repo at
  # scripts/fieldnote (single source of truth). We read it from the pinned flake
  # input here, and scripts/setup-agent-fieldnotes.sh copies the same file for
  # non-NixOS machines — so the Nix packaging and the imperative bootstrap never
  # drift. Edit scripts/fieldnote in the repo, not this module.
  fieldnoteScript = builtins.readFile "${inputs.agent-fieldnotes}/scripts/fieldnote";
  fieldnote = pkgs.writeShellScriptBin "fieldnote" fieldnoteScript;
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
         (clones the KB to ~/.local/share/agent-fieldnotes if needed; creates
         entries/<id>.yaml as a draft and validates it locally).
      2. Fill in problem / solution / repro in that file.
      3. Commit + push (CI validates + publishes to GitHub Pages).
         The clone is at ~/.local/share/agent-fieldnotes. Use a short alias:
           export KB=~/.local/share/agent-fieldnotes
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
