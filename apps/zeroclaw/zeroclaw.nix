{ inputs, pkgs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.system};
in
{
  home.packages = [ llm.zeroclaw ];

  # SECURITY: ~/.zeroclaw/config.toml may contain API keys and channel tokens.
  # Do NOT put secrets in this file — it is world-readable in the Nix store.
  # Instead, use one of:
  #   a) sops-nix: decrypt secrets at activation time and write/merge into
  #      ~/.zeroclaw/config.toml with mode 0600 via home.activation
  #   b) zeroclaw onboard: run once manually to write credentials
  #   c) zeroclaw auth login: per-provider OAuth flow (writes encrypted
  #      auth-profiles.json, no plain-text key in config.toml)
  #
  # Run `zeroclaw config schema` to explore all available options.
  # Run `zeroclaw doctor` after any config change to verify setup.
  xdg.configFile."zeroclaw/config-skeleton.toml".text = ''
    # ZeroClaw configuration skeleton — copy values you want to
    # ~/.zeroclaw/config.toml and fill in secrets there (not here).
    # See: https://github.com/zeroclaw-labs/zeroclaw/blob/master/docs/reference/api/config-reference.md

    # ── Provider ─────────────────────────────────────────────────────────────
    # default_provider = "anthropic"    # or "openrouter", "openai", "gemini"
    # default_model    = "anthropic/claude-sonnet-4-6"
    # api_key          = ""             # set via `zeroclaw auth login` instead

    # ── Gateway (web dashboard + channel control plane) ───────────────────────
    [gateway]
    host = "127.0.0.1"   # never expose publicly without a reverse-proxy + auth
    port = 42617
    require_pairing  = true
    allow_public_bind = false

    # ── Autonomy ─────────────────────────────────────────────────────────────
    [autonomy]
    level = "supervised"    # read_only | supervised | full
    workspace_only = true
    allowed_commands = ["git", "nix", "just", "fish", "bash", "sh", "ls", "cat"]
    max_actions_per_hour = 30

    # ── Agent ────────────────────────────────────────────────────────────────
    [agent]
    max_tool_iterations = 15
    max_history_messages = 60

    # ── Memory ───────────────────────────────────────────────────────────────
    [memory]
    backend  = "sqlite"
    auto_save = true

    # ── Cost guard ───────────────────────────────────────────────────────────
    [cost]
    enabled           = true
    daily_limit_usd   = 5.00
    monthly_limit_usd = 50.00
    warn_at_percent   = 80

    # ── Skills ───────────────────────────────────────────────────────────────
    [skills]
    # open_skills_enabled = true   # opt-in: clones agentskills community repo
    # open_skills_dir = "~/open-skills"
    prompt_injection_mode = "compact"  # saves context on first turn

    # ── Reliability ──────────────────────────────────────────────────────────
    # [reliability]
    # fallback_providers = ["openrouter"]
  '';
}
