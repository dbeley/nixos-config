{ inputs, pkgs, ... }:
let
  fieldnote = pkgs.writeShellScriptBin "fieldnote" (
    builtins.readFile "${inputs.agent-fieldnotes}/scripts/fieldnote"
  );
  klog-read = pkgs.writeShellScriptBin "klog-read" (
    builtins.readFile "${inputs.agent-fieldnotes}/scripts/klog-read.sh"
  );
in
{
  home.packages = [
    fieldnote
    klog-read
  ];

  xdg.configFile."opencode/AGENTS.md".text = ''
    # Field notes (klog) — read + capture protocol

    A shared, agent-maintained knowledge base of hard-won findings lives at
    https://dbeley.github.io/agent-fieldnotes/ (schema: klog). Use it BEFORE
    solving a hard problem, and CONTRIBUTE to it when you discover something.

    ## READ — query the KB before tackling a hard problem
      klog-read search "<term>"                 # find candidate entries by keyword
      klog-read filter --os=nixos --status=verified
      klog-read show <id>                        # full entry (problem/solution/repro)
      klog-read assess <id> --os=nixos --tool=uv # env-compat check + advisory
      klog-read nix <id>                         # run the hermetic NixOS repro (if any)
    If a verified, env-compatible entry matches, apply it (repro first) before
    starting from scratch.

    ## CAPTURE — publish new findings
    While working, if you discover something yourself that is NOT already well
    documented on the internet (or is only scattered across many sources), and
    it is reusable and would help another agent or human, publish it:

      1. Run:  fieldnote "One line title of the finding"
         (clones/updates the KB at ~/.local/share/agent-fieldnotes; creates
         entries/<id>.yaml as a draft and validates it locally).
      2. Fill in problem / solution / repro in that file.
      3. Commit + push (CI validates + publishes to GitHub Pages):
           export KB=~/.local/share/agent-fieldnotes
           git -C "$KB" add entries/<id>.yaml
           git -C "$KB" commit
           git -C "$KB" push

    ## When NOT to publish
    - Trivial / obvious things that one search finds.
    - One-off task output or progress.
    - Anything already documented in a canonical place.
    - Secrets, credentials, personal data.

    ## Rules
    - Keep new entries `status: draft` unless you actually re-ran the repro and
      saw the expected output (CI enforces that verified needs proof).
    - Include `repro` (steps + expected_output) on every entry.
    - Prefer CC0 license so the knowledge is freely redistributable.

    Live site: https://dbeley.github.io/agent-fieldnotes/
    Search index (agents): https://dbeley.github.io/agent-fieldnotes/search.json
  '';
}
