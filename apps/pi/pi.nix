{ inputs, pkgs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.system};

  pi-memory = pkgs.stdenvNoCC.mkDerivation {
    pname = "pi-memory";
    version = "0.4.2";
    src = pkgs.fetchFromGitHub {
      owner = "jayzeng";
      repo = "pi-memory";
      tag = "v0.4.2";
      hash = "sha256-20hbBZ3loTvpun+CTUp2dRU77eKtSw4J2bS8rvsRGgM=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };

  pi-web-access = pkgs.buildNpmPackage {
    pname = "pi-web-access";
    version = "0.47.0";
    src = pkgs.fetchFromGitHub {
      owner = "nicobailon";
      repo = "pi-web-access";
      tag = "v0.47.0";
      hash = "sha256-QfwEKSqOTc/VhPonFySNsgDAOkx9ROf+PnEF9v/iCow=";
    };
    npmDepsHash = "sha256-W8NDa2tq+qGxF4z4lTQXF6mNAOC3bWiuyeeNIIEbStc=";
    npmFlags = [
      "--omit=dev"
      "--omit=peer"
    ];
    dontNpmBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };

  settings = pkgs.writeText "pi-settings.json" (
    builtins.toJSON {
      defaultProvider = "opencode-go";
      defaultModel = "deepseek-v4.1-flash";
      defaultThinkingLevel = "medium";
      lastChangelogVersion = "1.5.0";
      defaultTools = [ "+codemode" ];
      packages = [
        "${pi-memory}"
        "${pi-web-access}"
      ];
    }
  );
in
{
  home.packages = [ llm.pi ];

  home.file = {
    ".pi/agent/settings.json" = {
      force = true;
      source = settings;
    };

    ".pi/agent/prompts/last30days.md" = {
      force = true;
      text = ''
        ---
        description: Research a topic across Reddit, X, YouTube, TikTok, HN, GitHub and the web
        argument-hint: "<topic>"
        ---
        Run the last30days skill to research this topic across all available sources: ''${@}
      '';
    };
  };
}
