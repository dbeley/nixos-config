{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    languages = {
      language-server = {
        pyright = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = [ "--stdio" ];
        };
        ruff = {
          command = "${pkgs.ruff}/bin/ruff";
          args = [ "server" ];
        };
        rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          config = {
            check.command = "clippy";
            cargo.features = "all";
          };
        };
        nixd = {
          command = "${pkgs.nixd}/bin/nixd";
        };
        command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
        args = [ "--stdio" ];
        config.provideFormatter = true;
      };
      marksman = {
        command = "${pkgs.marksman}/bin/marksman";
        args = [ "server" ];
      };
      language = [
        {
          name = "python";
          auto-format = true;
          language-servers = [
            "pyright"
            "ruff"
          ];
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = [
              "format"
              "--quiet"
              "-"
            ];
          };
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
        }
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nixd" ];
          formatter = {
            command = "${pkgs.nixfmt}/bin/nixfmt";
          };
        }
        {
          name = "json";
          auto-format = false;
          language-servers = [ "vscode-json-language-server" ];
        }
        {
          name = "csv";
          auto-format = false;
        }
        {
          name = "markdown";
          auto-format = false;
          language-servers = [ "marksman" ];
        }
      ];
    };
    settings = {
      editor = {
        cursorline = true;
        cursorcolumn = false;
        auto-completion = true;
        auto-format = true;
        auto-save = false;
        scrolloff = 5;
        auto-pairs = true;
      };
    };
  };
  home.packages = with pkgs; [
    pyright
    ruff
    rust-analyzer
    nixd
    vscode-langservers-extracted
    marksman
    nixfmt
  ];
}
