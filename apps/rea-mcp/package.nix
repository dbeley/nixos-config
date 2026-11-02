# REA MCP server, shared by the OpenCode and Hermes modules.
#
# `npx` is a JS script with a `#!/usr/bin/env node` shebang, so node must be on
# PATH when the server starts; neither host installs node globally.
#
# nodejs_22 is used because rea-agents supports ^22.23.4, ^24.22.1 or
# >=26.12.1 while nixpkgs' nodejs_24 is 24.21.0 (just below its minimum).
{ pkgs }:
pkgs.writeShellScript "rea-mcp" ''
  export PATH=${pkgs.nodejs_22}/bin:$PATH
  exec ${pkgs.nodejs_22}/bin/npx -y rea-agents@6.8.0 mcp "$@"
''
