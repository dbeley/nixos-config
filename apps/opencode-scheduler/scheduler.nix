{
  config,
  pkgs,
  lib,
  ...
}:

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
    runtimeInputs = with pkgs; [
      jq
      git
      gh
      curl
    ];
    text = builtins.readFile ./scripts/run-job.sh;
  };
in
{
  options.opencode-scheduler = {
    enable = lib.mkEnableOption "opencode-scheduler";
  };

  config = lib.mkIf cfg.enable {
    home.file = lib.mkMerge [
      (lib.mkMerge (
        map (name: {
          ".config/opencode/skills/${name}/SKILL.md" = {
            source = ./skills/${name}/SKILL.md;
          };
        }) skillNames
      ))
      {
        ".config/opencode/agent/scheduled-job.md".source = ./agent/scheduled-job.md;
      }
      {
        ".config/opencode-scheduler/config.json".source = ./config.json;
      }
      {
        ".config/opencode-scheduler/.keep".text = "";
        ".local/share/opencode-scheduler/logs/.keep".text = "";
      }
    ];

    home.packages = [ runScript ];

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
      }) dailyJobs)
      ++ (map (name: {
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
