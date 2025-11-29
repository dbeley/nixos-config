# Contributing to nixos-config

Thank you for your interest in contributing to this NixOS configuration! This document provides guidelines and instructions for contributing.

## Getting Started

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- [Git](https://git-scm.com/)
- Basic knowledge of NixOS and Nix language

### Setting Up the Development Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/dbeley/nixos-config.git
   cd nixos-config
   ```

2. Enter the development shell:
   ```bash
   nix develop
   ```

   This will:
   - Install pre-commit hooks automatically
   - Provide all necessary development tools (nixfmt, statix, deadnix, just, etc.)
   - Display helpful commands and information

## Development Workflow

### Running Checks Locally

Before committing your changes, ensure all checks pass:

1. **Format your code:**
   ```bash
   nix fmt
   ```

2. **Run all flake checks:**
   ```bash
   nix flake check
   ```

3. **Run specific linters:**
   ```bash
   # Statix - Nix linter
   nix run nixpkgs#statix -- check .

   # Deadnix - Find dead/unused code
   nix run nixpkgs#deadnix -- .
   ```

### Pre-commit Hooks

Pre-commit hooks are automatically installed when you enter the development shell (`nix develop`). They will run on every commit to ensure code quality.

The hooks include:
- `nixfmt` - Automatic Nix code formatting
- `statix` - Nix static analysis
- `deadnix` - Dead code detection
- `actionlint` - GitHub Actions workflow linting
- `check-merge-conflict` - Prevent committing merge conflicts
- `check-added-large-files` - Prevent committing large files
- `end-of-file-fixer` - Ensure files end with newline
- `trailing-whitespace` - Remove trailing whitespace

If you need to bypass pre-commit hooks (not recommended):
```bash
git commit --no-verify
```

### Testing Configuration Changes

To test your changes on a specific host:

```bash
# Dry-run to see what would change
nixos-rebuild dry-activate --flake .#<host>

# Build the configuration
nix build .#nixosConfigurations.<host>.config.system.build.toplevel

# Apply changes (on NixOS)
just switch  # using justfile with HOST env var set
# or
sudo nixos-rebuild switch --flake .#<host>
```

### Using Just

This repository uses [just](https://github.com/casey/just) for common tasks. Create a `.env` file with your host:

```bash
echo "HOST=<your-host>" > .env
```

Available recipes:
```bash
just --list       # List all available recipes
just switch       # Rebuild and switch to new configuration
just boot         # Rebuild for next boot
just update       # Update flake inputs
just clean        # Clean up old generations
just optimize     # Optimize Nix store
```

## Making Changes

### Code Style

- Follow the existing code style in the repository
- Use 2-space indentation for Nix files
- Keep lines under 100 characters when reasonable
- Use descriptive variable and function names
- Add comments for complex logic

### Commit Messages

Follow conventional commits format:

```
<type>: <description>

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements

Examples:
```
hyprland: add window rules for Firefox
niri: update configuration for better touchscreen support
docs: update README with new host information
chore: update flake inputs
```

### Pull Request Process

1. **Fork the repository** (for external contributors)

2. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes** following the guidelines above

4. **Test thoroughly:**
   - Run `nix flake check`
   - Test on relevant hosts if possible
   - Ensure no breaking changes

5. **Commit your changes** with descriptive messages

6. **Push to your fork** and create a pull request

7. **Ensure CI passes:**
   - All format checks pass
   - Flake check succeeds
   - Build checks complete successfully
   - Linters (statix, deadnix) pass

8. **Respond to review feedback** if any

## Repository Structure

- `apps/` - Application-specific configurations (DE, editors, browsers, etc.)
- `hosts/` - Per-host configurations
- `modules/` - Shared NixOS modules (base system, hardware, etc.)
- `flake.nix` - Main flake configuration
- `treefmt.nix` - Formatting configuration
- `justfile` - Common tasks and commands
- `.github/` - GitHub Actions workflows and templates

## Adding a New Host

1. Generate hardware configuration:
   ```bash
   nixos-generate-config --no-filesystems
   ```

2. Copy to `hosts/<hostname>/hardware-configuration.nix`

3. Add host definition in `hosts/default.nix`:
   ```nix
   <hostname> = mkHost {
     hostName = "<hostname>";
     stateVersion = "25.05";
     profiles = [
       # Add desired profiles
       "laptop"
       "niri"
       # etc.
     ];
     extraModules = [
       # Add any extra modules
     ];
   };
   ```

4. Test the configuration:
   ```bash
   nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel
   ```

## Getting Help

- Check existing issues and discussions
- Review the [README.md](README.md) for basic usage
- Look at similar configurations in `hosts/` for examples
- Ask questions in issue discussions

## Code of Conduct

- Be respectful and constructive
- Focus on what is best for the project
- Show empathy towards other contributors
- Accept constructive criticism gracefully

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Thank You!

Your contributions help make this NixOS configuration better for everyone. Thank you for taking the time to contribute! 🎉
