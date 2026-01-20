{
  pkgs,
  ...
}:
{
  # MCP (Model Context Protocol) integration for NixOS-specific tools
  # This provides OpenCode with access to NixOS package information, options, and system queries

  home.packages = with pkgs; [
    # Add mcp-nixos if available in nixpkgs, or fetch from GitHub
    # For now, we'll set up the configuration structure
    # The actual mcp-nixos server can be installed separately or added as a flake input
  ];

  # MCP server configuration for OpenCode
  # OpenCode typically looks for MCP configuration in ~/.config/opencode/mcp.json
  # or similar location. Adjust the path based on OpenCode's actual configuration format.
  xdg.configFile."opencode/mcp.json".text = builtins.toJSON {
    mcpServers = {
      nixos = {
        command = "nix";
        args = [
          "run"
          "github:utensils/mcp-nixos"
        ];
        env = { };
      };
    };
  };

  # Alternative: If OpenCode uses a different config format, create a shell script
  # that sets up the MCP server connection
  home.file.".local/bin/mcp-nixos-server".text = ''
    #!/usr/bin/env bash
    # MCP server wrapper for mcp-nixos
    # This can be used to start the MCP server manually or via OpenCode configuration
    exec ${pkgs.nix}/bin/nix run github:utensils/mcp-nixos "$@"
  '';

  home.file.".local/bin/mcp-nixos-server".executable = true;
}
