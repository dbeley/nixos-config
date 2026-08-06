{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = {
        systems.follows = "systems";
      };
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nur = {
      url = "github:nix-community/nur";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    base16 = {
      # url = "github:SenchoPens/base16.nix?ref=refs/pull/19/head";
      url = "github:SenchoPens/base16.nix";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        base16.follows = "base16";
        nur.follows = "nur";
      };
    };
    ucodenix = {
      url = "github:e-tho/ucodenix";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs = {
        blueprint.follows = "blueprint";
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    blueprint = {
      url = "github:numtide/blueprint";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    obra-superpowers = {
      url = "github:obra/superpowers";
      flake = false;
    };
    last30days-skill = {
      url = "github:mvanhorn/last30days-skill";
      flake = false;
    };
    ponytail = {
      url = "github:DietrichGebert/ponytail";
      flake = false;
    };
    symmetri = {
      url = "github:dbeley/symmetri";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    cairn = {
      url = "github:dbeley/cairn";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    impulse = {
      url = "github:dbeley/impulse";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    hermes-webui = {
      url = "github:nesquena/hermes-webui";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    maloja = {
      url = "github:dbeley/maloja";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    covertone = {
      url = "github:dbeley/covertone";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      user = "david";

      eachSystem = nixpkgs.lib.genAttrs supportedSystems;

      hostConfigs = import ./hosts {
        inherit
          nixpkgs
          inputs
          user
          ;
        inherit (nixpkgs) lib;
      };
    in
    {
      checks = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          pre-commit-check = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            package = pkgs.prek;
            hooks = {
              nixfmt.enable = true;
              statix.enable = true;
              deadnix.enable = true;
              end-of-file-fixer.enable = true;
              ruff.enable = true;
              shellcheck.enable = true;
            };
          };
        }
      );

      devShells = eachSystem (system: {
        default =
          let
            pkgs = nixpkgs.legacyPackages.${system};
            inherit (self.checks.${system}.pre-commit-check) shellHook enabledPackages;
          in
          pkgs.mkShell {
            inherit shellHook;
            buildInputs = enabledPackages;
            shell = pkgs.fish;
          };
      });

      nixosConfigurations = hostConfigs;
    };
}
