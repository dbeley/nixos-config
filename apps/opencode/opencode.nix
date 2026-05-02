{ inputs, pkgs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.system};
  opencode-wrapped = pkgs.symlinkJoin {
    name = "opencode-wrapped";
    paths = [ llm.opencode ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/opencode --set OPENCODE_ENABLE_EXA 1
    '';
  };
in
{
  home.packages = [
    opencode-wrapped
    llm.rtk
    pkgs.libnotify
  ];
  xdg.configFile = {
    "opencode/opencode.json" = {
      force = true;
      text = builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        autoshare = false;
        theme = "system";
        plugin = [
          "@mohak34/opencode-notifier@latest"
        ];
      };
    };
    "opencode/opencode-notifier.json" = {
      force = true;
      text = builtins.toJSON {
        sound = false;
        notification = true;
        bell = false;
        timeout = 5;
        showProjectName = true;
        showSessionTitle = false;
        showIcon = true;
        suppressWhenFocused = true;
        enableOnDesktop = false;
        linux = {
          grouping = true;
        };
        minDuration = 0;
        events = {
          permission = {
            sound = false;
            notification = true;
            command = false;
            bell = false;
          };
          complete = {
            sound = false;
            notification = true;
            command = false;
            bell = false;
          };
          subagent_complete = {
            sound = false;
            notification = false;
            command = false;
            bell = false;
          };
          error = {
            sound = false;
            notification = true;
            command = false;
            bell = false;
          };
          question = {
            sound = false;
            notification = true;
            command = false;
            bell = false;
          };
          user_cancelled = {
            sound = false;
            notification = false;
            command = false;
            bell = false;
          };
          plan_exit = {
            sound = false;
            notification = true;
            command = false;
            bell = false;
          };
          session_started = {
            sound = false;
            notification = false;
            command = false;
            bell = false;
          };
          user_message = {
            sound = false;
            notification = false;
            command = false;
            bell = false;
          };
          client_connected = {
            sound = false;
            notification = false;
            command = false;
            bell = false;
          };
        };
      };
    };
    "opencode/plugins/rtk.ts" = {
      force = true;
      text = ''
          import type { Plugin } from "@opencode-ai/plugin"

        // RTK OpenCode plugin — rewrites commands to use rtk for token savings.
        // Requires: rtk >= 0.23.0 in PATH.
        //
        // This is a thin delegating plugin: all rewrite logic lives in `rtk rewrite`,
        // which is the single source of truth (src/discover/registry.rs).
        // To add or change rewrite rules, edit the Rust registry — not this file.

        export const RtkOpenCodePlugin: Plugin = async ({ $ }) => {
          try {
            await $`which rtk`.quiet()
          } catch {
            console.warn("[rtk] rtk binary not found in PATH — plugin disabled")
            return {}
          }

          return {
            "tool.execute.before": async (input, output) => {
              const tool = String(input?.tool ?? "").toLowerCase()
              if (tool !== "bash" && tool !== "shell") return
              const args = output?.args
              if (!args || typeof args !== "object") return

              const command = (args as Record<string, unknown>).command
              if (typeof command !== "string" || !command) return

              try {
                const result = await $`rtk rewrite ''${command}`.quiet().nothrow()
                const rewritten = String(result.stdout).trim()
                if (rewritten && rewritten !== command) {
                  ;(args as Record<string, unknown>).command = rewritten
                }
              } catch {
                // rtk rewrite failed — pass through unchanged
              }
            },
          }
        }
      '';
    };
  };
}
